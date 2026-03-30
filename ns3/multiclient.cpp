#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
using namespace ns3;
NS_LOG_COMPONENT_DEFINE("ChatSimulation");
// SERVER
class ServerApp : public Application
{
private:
Ptr<Socket> socket;
void ReceivePacket(Ptr<Socket> socket)
{
Ptr<Packet> packet;
Address from;
while((packet = socket->RecvFrom(from)))
{
uint32_t packetSize = packet->GetSize();
double time = Simulator::Now().GetSeconds();
std::stringstream ss;
ss<<"Processed at "<<time<<"s , Size="<<packetSize<<" bytes";
std::string reply = ss.str();
Ptr<Packet> response = Create<Packet>((uint8_t*)reply.c_str(),reply.length());
socket->SendTo(response,0,from);
NS_LOG_UNCOND("Server calculated result and sent reply");
}
}

public:
void StartApplication()
{
socket = Socket::CreateSocket(GetNode(),UdpSocketFactory::GetTypeId());
socket->Bind(InetSocketAddress(Ipv4Address::GetAny(),8080));
socket->SetRecvCallback(MakeCallback(&ServerApp::ReceivePacket,this));
}
};
// CLIENT
class ClientApp : public Application
{
private:
Ptr<Socket> socket;
Address serverAddr;
std::string name;
Time interval;
void SendMessage()
{
std::string msg="Message from "+name;
Ptr<Packet> packet=Create<Packet>((uint8_t*)msg.c_str(),msg.length());
socket->Send(packet);
Simulator::Schedule(interval,&ClientApp::SendMessage,this);
}
void ReceiveReply(Ptr<Socket> socket)
{
Ptr<Packet> packet=socket->Recv();
uint8_t *buffer=new uint8_t[packet->GetSize()];
packet->CopyData(buffer,packet->GetSize());

std::string data=(char*)buffer;
NS_LOG_UNCOND(name<<" received -> "<<data);
}
public:
void Setup(Address addr,Time t,std::string n)
{
serverAddr=addr;
interval=t;
name=n;
}
void StartApplication()
{
socket=Socket::CreateSocket(GetNode(),UdpSocketFactory::GetTypeId());
socket->Connect(serverAddr);
socket->SetRecvCallback(MakeCallback(&ClientApp::ReceiveReply,this));
SendMessage();
}
};
// MAIN
int main()
{
NodeContainer nodes;
nodes.Create(3);
PointToPointHelper link;
link.SetDeviceAttribute("DataRate",StringValue("5Mbps"));
link.SetChannelAttribute("Delay",StringValue("3ms"));
NetDeviceContainer d1=link.Install(nodes.Get(0),nodes.Get(1));
NetDeviceContainer d2=link.Install(nodes.Get(0),nodes.Get(2));
InternetStackHelper stack;
stack.Install(nodes);
Ipv4AddressHelper address;
address.SetBase("10.1.1.0","255.255.255.0");
Ipv4InterfaceContainer i1=address.Assign(d1);
address.SetBase("10.1.2.0","255.255.255.0");
Ipv4InterfaceContainer i2=address.Assign(d2);
// SERVER INSTALL
Ptr<ServerApp> server=CreateObject<ServerApp>();
nodes.Get(0)->AddApplication(server);
// CLIENT 1
Ptr<ClientApp> c1=CreateObject<ClientApp>();
c1->Setup(InetSocketAddress(i1.GetAddress(0),8080),Seconds(3),"Client1");
nodes.Get(1)->AddApplication(c1);
// CLIENT 2
Ptr<ClientApp> c2=CreateObject<ClientApp>();
c2->Setup(InetSocketAddress(i2.GetAddress(0),8080),Seconds(5),"Client2");
nodes.Get(2)->AddApplication(c2);
Simulator::Stop(Seconds(15));
Simulator::Run();
Simulator::Destroy();
}
