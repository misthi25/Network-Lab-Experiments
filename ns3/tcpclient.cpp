#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/applications-module.h"
using namespace ns3;
int main ()
{
 Time::SetResolution (Time::NS);
 // create nodes
 NodeContainer nodes;
 nodes.Create (2);
 // create link
 PointToPointHelper p2p;
 p2p.SetDeviceAttribute ("DataRate", StringValue ("5Mbps"));
 p2p.SetChannelAttribute ("Delay", StringValue ("2ms"));

 NetDeviceContainer devices = p2p.Install (nodes);
 // install internet stack
 InternetStackHelper internet;
 internet.Install (nodes);
 // assign IP address
 Ipv4AddressHelper ipv4;
 ipv4.SetBase ("10.1.1.0", "255.255.255.0");
 Ipv4InterfaceContainer interfaces = ipv4.Assign (devices);
 uint16_t port = 8080;
 // TCP SERVER using PacketSink
 PacketSinkHelper server ("ns3::TcpSocketFactory",
 InetSocketAddress (Ipv4Address::GetAny (), port));

 ApplicationContainer serverApp = server.Install (nodes.Get (1));
 serverApp.Start (Seconds (1.0));
 serverApp.Stop (Seconds (15.0));
 // TCP CLIENT using OnOffApplication
 OnOffHelper client ("ns3::TcpSocketFactory",
 InetSocketAddress (interfaces.GetAddress (1), port));
 client.SetAttribute ("PacketSize", UintegerValue (1024));
 client.SetAttribute ("DataRate", StringValue ("1Mbps"));
 ApplicationContainer clientApp = client.Install (nodes.Get (0));

 clientApp.Start (Seconds (2.0));
 clientApp.Stop (Seconds (15.0));
 Simulator::Run ();
 Simulator::Destroy ();
 return 0;
}
