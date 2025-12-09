#include <core.p4>
#include <v1model.p4>

/*************************************************************************
*********************** DEFINIÇÕES ***************************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;

/*************************************************************************
*********************** HEADERS ******************************************
*************************************************************************/

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

struct metadata { }

struct headers {
    ethernet_t ethernet;
}

/*************************************************************************
*********************** PARSER *******************************************
*************************************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        packet.extract(hdr.ethernet);
        transition accept;
    }
}

/*************************************************************************
*********************** CHECKSUM *****************************************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply { }
}

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
    apply { }
}

/*************************************************************************
*********************** INGRESS ******************************************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

    action drop() {
        mark_to_drop(standard_metadata);
    }

    action forward(egressSpec_t port) {
        standard_metadata.egress_spec = port;
    }

    // Flood simples: envia para várias portas fixas (ajuste conforme sua topologia)
    action flood() {
        // Exemplo bem simples: envia sempre para porta 1
        // (em produção, use grupos multicast e/ou replicação)
        if (standard_metadata.ingress_port != 1) {
            standard_metadata.egress_spec = 1;
        } else {
            standard_metadata.egress_spec = 2;
        }
    }

    table mac_table {
        key = {
            hdr.ethernet.dstAddr : exact;
        }
        actions = {
            forward;
            drop;
            flood;
            NoAction;
        }
        size = 1024;
        default_action = flood();
    }

    apply {
        if (hdr.ethernet.isValid()) {
            mac_table.apply();
        }
    }
}

/*************************************************************************
*********************** EGRESS *******************************************
*************************************************************************/

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply { }
}

/*************************************************************************
*********************** DEPARSE ******************************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
    }
}

/*************************************************************************
*********************** SWITCH *******************************************
*************************************************************************/

V1Switch(
    MyParser(),
    MyVerifyChecksum(),
    MyIngress(),
    MyEgress(),
    MyComputeChecksum(),
    MyDeparser()
) main;
