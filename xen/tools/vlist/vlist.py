#!/usr/bin/python3
#
# PCAD Netlist converter to Verilog pattern
# Copyright (c) 2019 1801BM1 <1801bm1@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import argparse
import copy
import re

DC303_AX = 0x070

netlist = {}
cmplist = {}
romlist = [-1]*0x200


class tcmp(object):
    def __init__(self):
        self.pins = {}
        self.attr = {}
        self.name = ""


class tnet(object):
    def __init__(self):
        self.nodes = {}
        self.name = ""


class netlist_state(object):
    STATE_IDLE = 0
    STATE_NETLIST = 1
    STATE_COMP = 2
    STATE_NET = 3
    STATE_NODE = 4

    def __init__(self):
        self.s = self.STATE_IDLE


valid_token = ["(", ")",
               "asciiHeader",
               "netlist",
               "compInst",
               "compRef",
               "originalName",
               "compValue",
               "patternName",
               "net",
               "node",
               "ACCEL_ASCII"]

valid_comp = ["compRef",
              "originalName",
              "compValue",
              "patternName"]


def sxerr(code, nline, token):
    print("Syntax error [%d] in line %d \"%s\"" % (code, nline, token))
    exit(-1)


#
# Load netlist from file in PCAD 2004 ASCII netlist format
#
def read_netlist(f, verb):
    state = netlist_state()
    nline = 0       # number of line
    ignor = 0       # amount of tokens to skip
    ncomp = 0       # amount of components processed
    nskip = 0       # parenthesses level to skip
    token = ""      # current token
    nnet = 0        # amount of nets processed
    comp = tcmp()   # current component
    cnet = tnet()   # current component
    pins = []       # node pin list

    print("Loading netlist file: %s" % f.name)
    for line in f:
        line = line.strip()
        nline += 1
        for mt in re.finditer(r"(\".+?\")|(\()|(\))|([^\s\n\)\(\"]+)", line):
            prev = token
            token = mt.group()
#
# Ignore all tokens in skip mode till level closure
#
            if nskip:
                if token == ")":
                    nskip -= 1
                    continue
                if token == "(":
                    nskip += 1
                continue
#
# Check whether token is supported
#
            if token.startswith('"') != token.endswith('"'):
                print("Line %d not paired quotes: %s" % (nline, line))
                exit(-1)

            if not token.startswith('"') and token not in valid_token:
                print("Line %d unrecognized token: %s" % (nline, token))
                exit(-1)
#
# Skip the specified amount if tokens
#
            if ignor:
                ignor -= 1
                continue

            if token == "asciiHeader":
                nskip = 1
                continue
            if token == "ACCEL_ASCII":
                ignor = 1
                continue
            if token == "(":
                continue

            if state.s == state.STATE_IDLE:
                if token == "netlist":
                    if prev == "(":
                        state.s = state.STATE_NETLIST
                        ignor = 1
                        continue
                sxerr(1, nline, token)

            if state.s == state.STATE_NETLIST:
                if token == ")":
                    state.s = state.STATE_IDLE
                    continue
                if prev == "(":
                    if token == "compInst":
                        comp = tcmp()
                        state.s = state.STATE_COMP
                        continue
                    if token == "net":
                        cnet = tnet()
                        state.s = state.STATE_NET
                        continue
                sxerr(2, nline, token)

            if state.s == state.STATE_COMP:
                if prev == "compInst":
                    if not token.startswith('"'):
                        sxerr(3, nline, token)
                    comp.name = token.strip('"')
                    continue
#
# Adding new component on "compInst" closure
#
                if token == ")":
                    if prev == ")":
                        state.s = state.STATE_NETLIST
                        if comp.name == "":
                            sxerr(4, nline, token)
                        cmplist[comp.name] = comp
                        ncomp += 1
                        if verb:
                            print("Adding component: %s" % comp.name)
                    continue

                if prev == "(":
                    if token not in valid_comp:
                        sxerr(5, nline, token)
                    continue

                if token.startswith('"'):
                    if prev not in valid_comp:
                        sxerr(6, nline, token)
                    comp.attr[prev] = token.strip('"')
                    continue
                sxerr(7, nline, token)

            if state.s == state.STATE_NET:
                if prev == "net":
                    if not token.startswith('"'):
                        sxerr(8, nline, token)
                    cnet.name = token.strip('"')
                    continue
#
# Adding new net on "net" closure
#
                if token == ")":
                    if prev == ")":
                        state.s = state.STATE_NETLIST
                        if cnet.name == "":
                            sxerr(9, nline, token)
                        netlist[cnet.name] = cnet
                        nnet += 1
                        if verb:
                            print("Adding net: %s" % cnet.name)
                    continue

                if prev == "(":
                    if token != "node":
                        sxerr(10, nline, token)
                    continue
#
# Open new node list
#
                if token.startswith('"') and prev == "node":
                    state.s = state.STATE_NODE
                    compName = token.strip('"')
                    comp = cmplist.get(compName, None)
                    if comp is None:
                        print("Component \"%s\" not found in line %d"
                              % (compName, nline))
                        exit(-1)
                    pins = []
                    continue
                sxerr(11, nline, token)

            if state.s == state.STATE_NODE:
                if token == ")":
                    if not pins:
                        sxerr(12, nline, token)
                    cnet.nodes[compName] = pins
                    state.s = state.STATE_NET
                    continue

                if not token.startswith('"'):
                    sxerr(11, nline, token)
                npin = int(token.strip('"'))
                pins.append(npin)
                comp.pins[npin] = cnet.name
                continue

            print("Invalid state %d", state.s)
            exit(-1)

    if nskip or ignor:
        print("Unexpected end of file (not closed skip)")
        exit(-1)

    print("%d lines, %d components, %d nets" % (nline, ncomp, nnet))
    return netlist, cmplist


def comp_by_pin(vnet, npin, type=None):
    rcmp = None
    for key in vnet.nodes:
        node = vnet.nodes[key]
        if len(node) == 1 and node[0] == npin:
            if type is not None:
                if cmplist[key].attr["patternName"] != type:
                    continue
            if rcmp is not None:
                print("Duplicated component in net", vnet.name)
                exit(-1)
            rcmp = copy.copy(key)
    if rcmp is not None:
        rcmp = cmplist[rcmp]
    return rcmp


def tc12_expand(l, tc, tlist):
    index = str.find(l, 'x')
    if index < 0:
        index = str.find(l, 'b')
        ad = int(l[index+1:index+12], base=2)
        print("   %s: tcr <= 7'h%02X;   // %04o: " % (l, tc, ad))
        tl = tlist.get(tc, None)
        if tl is None:
            tlist[tc] = [ad]
            return
        tl.append(ad)
        return
    str0 = " " + l[:index] + '0' + l[index+1:]
    tc12_expand(str0, tc, tlist)
    str1 = " " + l[:index] + '1' + l[index+1:]
    tc12_expand(str1, tc, tlist)


def proc_1621_12(verb):
    vlist = []
    vdict = {}
    vlitc = {}
    for i in range(88):
        vlink = "VLINK_%02d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)
        vcmp = comp_by_pin(vnet, 1)
        if vcmp is None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[3]]
        seta = 0
        clra = 0
        for t in pnet.nodes:
            nodes = pnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if re.fullmatch(r"LC\d{1,2}", l):
                    clra |= 1 << int(l[2:])
                    continue
                if re.fullmatch(r"~LC\d{1,2}", l):
                    seta |= 1 << int(l[3:])
                    continue
                if l == "RNI" or l == "NET00290":
                    continue
                print("Net: %s unrecognized peer %s/%s" % (vnet.name, l, t))
                exit(-1)

        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
#
# p[50] and p[75] of array are not used by 1621 LSI-11/03
#
            if vnet.name != "VLINK_50" and vnet.name != "VLINK_75":
                return
            continue
        l = ""
        for j in range(11):
            if seta & (1 << j):
                l = "1" + l
                continue
            if clra & (1 << j):
                l = "0" + l
                continue
            l = "x" + l
        if verb:
            print("%s: 11'b%s" % (vnet.name, l))
        seta = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 2:
                s = cmplist[t].pins[3]
                if re.fullmatch(r"~TC\d", s):
                    seta |= 1 << int(s[3:])
        vlist.append(l)
        vdict[l] = i
        vlitc[l] = seta
#
# Check the TC output number of set bits (must be 3 for array 1/2)
#
        nb = 0
        while seta != 0:
            if seta & 0x01:
                nb += 1
            seta >>= 1
        if nb != 3:
            print("Net: %s output %02X error" % (vnet.name, vlitc[l]))

    print("\r\nSorted by product index [1621 arrays 1/2]")
    for l in vlist:
        print("assign pl[%d] = cmp(lc, 11'b%s);" % (vdict[l], l))
    vlist.sort()
    print("\r\nSorted by LC address [1621 arrays 1/2]")
    for l in vlist:
        print("assign pl[%d] = cmp(lc, 11'b%s);" % (vdict[l], l))
    print("\r\nCase table [1621 arrays 1/2]")
    tcalist = {}
    for l in vlist:
        tc12_expand("11'b" + l, vlitc[l], tcalist)
    lktc = list(tcalist.keys())
    lktc.sort()
    print("\r\nTCA codes generated [1621 arrays 1/2]")
    for i in lktc:
        print("\r\n%02X: " % i, end="")
        print([oct(x) for x in tcalist[i]], end="")
    print(tcalist)


def proc_1621_34(verb):
    lta = []
    lra = []
    ltsr = []
    tsra = [[], [], []]
    pta = [[], [], [], [], [], [], [], [], [], [], []]

    for i in range(100):
        vlink = "TLINK_%02d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)

        vcmp = comp_by_pin(vnet, 1)
        if vcmp is None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[2]]
        if pnet.name != "V1":
            print("No V1 on tranceiving component found in net %s" % vnet.name)
            exit(-1)

        pnet = netlist[vcmp.pins[3]]
        seta = 0
        clra = 0
        for t in pnet.nodes:
            nodes = pnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if re.fullmatch(r"TR[0-7]", l):
                    clra |= 1 << int(l[2:])
                    continue
                if re.fullmatch(r"~TR[0-7]", l):
                    seta |= 1 << int(l[3:])
                    continue
                if re.fullmatch(r"TC[0-6]", l):
                    clra |= 1 << (int(l[2:]) + 8)
                    continue
                if re.fullmatch(r"~TC[0-6]", l):
                    seta |= 1 << (int(l[3:]) + 8)
                    continue
                if re.fullmatch(r"IRQ[1-7]", l):
                    clra |= 1 << (int(l[3:]) + 15 - 1)
                    continue
                if re.fullmatch(r"~IRQ[1-7]", l):
                    seta |= 1 << (int(l[4:]) + 15 - 1)
                    continue
                if re.fullmatch(r"TSR[0-1]", l):
                    clra |= 1 << (int(l[3:]) + 22)
                    continue
                if re.fullmatch(r"~TSR[0-1]", l):
                    seta |= 1 << (int(l[4:]) + 22)
                    continue
                if l == "QTR":
                    clra |= 1 << 24
                    continue
                if l == "V1":
                    continue
                print("Net: %s unrecognized peer %s" % (vnet.name, l))
                exit(-1)

        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
        if verb:
            print("%s: 25'b%s" % (vnet.name, l))

        tr = ""
        for j in range(0, 8):
            if seta & (1 << j):
                tr = "1" + tr
                continue
            if clra & (1 << j):
                tr = "0" + tr
                continue
            tr = "x" + tr

        tc = ""
        nb = 0
        for j in range(8, 15):
            if seta & (1 << j):
                tc = "1" + tc
                nb += 1
                continue
            if clra & (1 << j):
                print("TC: invalid zero in the net %s" % vlink)
                exit(-1)
            tc = "x" + tc
        if nb != 3 and nb != 4:
            print("TC: %s invalid for the net %s" % (tc, vlink))
            exit(-1)

        irq = ""
        for j in range(15, 22):
            if seta & (1 << j):
                irq = "1" + irq
                continue
            if clra & (1 << j):
                irq = "0" + irq
                continue
            irq = "x" + irq

        tsr = ""
        for j in range(22, 24):
            if seta & (1 << j):
                tsr = "1" + tsr
                continue
            if clra & (1 << j):
                tsr = "0" + tsr
                continue
            tsr = "x" + tsr

        if clra & (1 << 24):
            q = "0"
        else:
            q = "x"

        if i < 84:
            if irq != "xxxxxxx":
                print("IRQ: %s invalid for the net %s" % (irq, vlink))
                exit(-1)
            print("assign p[%d] = cmp({q, ts, tc, tr}, {1'b%s, 2'b%s, 7'b%s, 8'b%s});"
                  % (i, q, tsr, tc, tr))
        else:
            if tr != "xxxxxxxx":
                print("TR: %s invalid for the net %s" % (tr, vlink))
                exit(-1)
            print("assign p[%d] = cmp({q, ts, tc, irq[7:1]}, {1'b%s, 2'b%s, 7'b%s, 8'bx%s});"
                  % (i, q, tsr, tc, irq))

        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            vcmp = cmplist[t]
            if len(nodes) != 1:
                print("Multiconnecton: %s %s" % (vlink, t))
                exit(-1)
            if nodes[0] != 2:
                continue
            if vcmp.pins[3] != "C4":
                print("No C4 found: %s %s" % (vlink, t))
                exit(-1)
            lname = vcmp.pins.get(1, None)
            if lname is None:
                continue
            if lname == "PLM_LTA":
                lta.append(i)
                continue
            if lname == "PLM_LRA":
                lra.append(i)
                continue
            lnet = netlist[lname]
            for mt in lnet.nodes:
                nodes = lnet.nodes[mt]
                vcmp = cmplist[mt]
                if len(nodes) != 1:
                    print("Multiconnecton: %s %s" % (lnet.name, mt))
                    exit(-1)
                if nodes[0] != 2:
                    continue
                lname = vcmp.pins[3]
                if lname == "~LDTSRA":
                    ltsr.append(i)
                    continue
                if re.fullmatch(r"~TSRA[0-2]", lname):
                    tsra[int(lname[5:])].append(i)
                    continue
                if re.fullmatch(r"~PTA\d{1,2}", lname):
                    pta[int(lname[4:])].append(i)
                    continue
                print("Net: %s unrecognized peer %s" % (lnet.name, lname))
                exit(-1)

    print("")
    l = "assign lra = "
    for i in lra:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign lta = "
    for i in lta:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign ltsr = "
    for i in ltsr:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign tsr[0] = "
    for i in tsra[0]:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign tsr[1] = "
    for i in tsra[1]:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign tsr[2] = "
    for i in tsra[2]:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])
    for j in range(11):
        l = "assign pta[%d] = " % j
        for i in pta[j]:
            l = l + "p[%d] | " % i
        print("%s;" % l[:-3])


def proc_1621_mr(verb):
    print("\r\nMicroinstruction decode array [1621]")
    for i in range(24):
        vlink = "MLINK_%02d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if re.fullmatch(r"MIR\d{1,2}", l):
                    clra |= 1 << int(l[3:])
                    continue
                if re.fullmatch(r"~MIR\d{1,2}", l):
                    seta |= 1 << int(l[4:])
                    continue
                if l == "PLMQ":
                    clra |= 1 << 16
                    continue
                if l == "+5V":
                    continue
                print("Net: %s unrecognized peer %s" % (vnet.name, l))
                exit(-1)

        if seta & clra or seta & 0xFF or clra & 0xFF:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)
        seta >>= 8
        clra >>= 8
        l = ""
        for j in range(9):
            if seta & (1 << j):
                l = "1" + l
                continue
            if clra & (1 << j):
                l = "0" + l
                continue
            l = "x" + l
        if verb:
            print("%s: 11'b%s" % (vnet.name, l))
        print("assign pl[%d] = cmp({plmq, mir[15:8]}, 9'b%s);" % (i, l))


def proc_1611(verb):
    pl_set = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
    pl_clr = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]

    for i in range(56):
        vlink = "PLINK_%02d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)
        vcmp = comp_by_pin(vnet, 3)
        if vcmp is None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[2]]
        if pnet.name != "V3":
            print("No V3 on tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[1]]
        seta = 0
        clra = 0
        for t in pnet.nodes:
            nodes = pnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if l == "PSW0":
                    clra |= 1 << 0
                    continue
                if l == "~PSW0":
                    seta |= 1 << 0
                    continue
                if l == "INPL":
                    clra |= 1 << 1
                    continue
                if re.fullmatch(r"MIR\d{1,2}", l):
                    clra |= 1 << int(l[3:])
                    continue
                if re.fullmatch(r"~MIR\d{1,2}", l):
                    seta |= 1 << int(l[4:])
                    continue

        if seta & clra or seta & 0xFC or clra & 0xFC:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)

        l = ""
        for j in range(8, 16):
            if seta & (1 << j):
                l = "1" + l
                continue
            if clra & (1 << j):
                l = "0" + l
                continue
            l = "x" + l
        if clra & 1 << 0:
            l = "0" + l
        else:
            if seta & 1 << 0:
                l = "1" + l
            else:
                l = "x" + l
        if clra & 1 << 1:
            l = "0" + l
        else:
            l = "x" + l

        if verb:
            print("%s: 11'b%s" % (vnet.name, l))
        print("assign p[%d] = cmp({inpl, psw[0], mir[15:8]}, 10'b%s);" % (i, l))

        vcmp = comp_by_pin(vnet, 2)
        if vcmp is None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[3]]
        if pnet.name != "C3" and pnet.name != "C4":
            print("No C3 on tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[1]]
        if re.fullmatch(r"PL\d{1,2}", pnet.name):
            pl = int(pnet.name[2:])
            pl_set[pl].append(i)
            continue
        for t in pnet.nodes:
            nodes = pnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 2:
                l = cmplist[t].pins[3]
                if re.fullmatch(r"PL\d{1,2}D", l):
                    pl = int(l[2:-1])
                    pl_clr[pl].append(i)
                    continue
                print("Unrecognized net %s found in net %s" % (l, vnet.name))
                exit(-1)

    print("")
    for i in range(13, 21):
        l = "assign pl[%d] = " % i
        for j in pl_set[i]:
            l = l + "p[%d] | " % j
        print("%s;" % l[:-3])
    print("")
    for i in range(14):
        l = "assign pl_n[%d] = " % i
        for j in pl_clr[i]:
            l = l + "p[%d] | " % j
        print("%s;" % l[:-3])


def proc_303_pla(verb):
    amax = 32
    pl = [0] * 25
    ma = []
    for i in range(128):
        ma.append(list())
    print("Decoding PLA matrix ...")
    for i in range(138):
        vlink = "P%d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)

        # gather mask for Pn-products for Hn/~Hn and In/~In
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if re.fullmatch(r"H[0-6]", l):
                    clra |= 1 << int(l[1:])
                    continue
                if re.fullmatch(r"~H[0-6]", l):
                    seta |= 1 << int(l[2:])
                    continue
                if re.fullmatch(r"I\d{1,2}", l):
                    clra |= 1 << (int(l[1:]) + 12)
                    continue
                if re.fullmatch(r"~I\d{1,2}", l):
                    seta |= 1 << (int(l[2:]) + 12)
                    continue

        if (seta & clra or seta & 0xF80 or clra & 0xF80 or
                seta >= (1 << 28) or clra >= (1 << 28)):
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)

        # update micro address dependency
        for j in range(128):
            if seta | clra:
                if (((j & seta) ^ seta) | ((~j & clra) ^ clra)) & 0x7F == 0:
                    ma[j].append(i)
        if (seta | clra) & 0x20 and amax < 64:
            amax = 64
        if (seta | clra) & 0x40 and amax < 128:
            amax = 128
        # convert mask to string like "000111xxxx"
        l = ""
        for j in range(27, -1, -1):
            if seta & (1 << j):
                l += "1"
                continue
            if clra & (1 << j):
                l += "0"
                continue
            l += "x"

        if verb:
            print("%s: %07X %07X -> %s" % (vlink, seta, clra, l))
        print("assign p[%d] = cmp({d_in, a_in}, {16'b%s, 7'b%s});"
              % (i, l[:16], l[-7:]))

    for i in range(25):
        plink = "PL%d" % (i * 4)
        pnet = netlist.get(plink, None)
        if pnet is None:
            print("Net %s not found in netlist" % plink)
            exit(-1)
        if verb:
            print(pnet.name, pnet.nodes)

        d = 0
        for t in pnet.nodes:
            nodes = pnet.nodes[t]
            if len(nodes) != 1:
                print("Net %s has invalid attachment %s" % (plink, t))
                exit(-1)
            cmp = cmplist[t]
            if cmp.pins[3] != plink:
                if (cmp.pins[1] == plink and
                        cmp.pins[2] == "CLK" and
                        cmp.pins[3] == "+5V"):
                    continue
                print("Net %s has invalid attachment %s" % (plink, t))
                exit(-1)
            if cmp.pins[1] != "GND":
                if cmp.pins[2] == "PG0":
                    continue
                print("Net %s has invalid attachment %s" % (plink, t))
                exit(-1)

            # find the Pn attachment through transistor chain
            vnet = netlist[cmp.pins[2]]
            for v in vnet.nodes:
                nodes = vnet.nodes[v]
                if len(nodes) != 1:
                    continue
                cmp = cmplist[v]
                if cmp.pins[1] == "~CLK":
                    cmp = comp_by_pin(netlist[cmp.pins[2]], 3)
                    if cmp is None or cmp.pins[2] != "~PSTB":
                        print("No tranceiving component found in net %s" % vnet.name)
                        exit(-1)
                    pname = cmp.pins[1]
                    if re.fullmatch(r"P\d{1,3}", pname):
                        d |= 1 << int(pname[1:])
                        break
                    print("Unrecognized net %s found in net %s"
                          % (pname, vnet.name))
                    exit(-1)
                if cmp.pins[3] == "~CLK":
                    cmp = comp_by_pin(netlist[cmp.pins[2]], 1)
                    if cmp is None or cmp.pins[2] != "~PSTB":
                        print("No tranceiving component found in net %s" % vnet.name)
                        exit(-1)
                    cmp = comp_by_pin(netlist[cmp.pins[3]], 1)
                    if cmp is None or cmp.pins[3] != "+12V":
                        print("No tranceiving component found in net %s" % vnet.name)
                        exit(-1)
                    pname = cmp.pins[2]
                    if re.fullmatch(r"P\d{1,3}", pname):
                        d |= 1 << int(pname[1:])
                        break
                    print("Unrecognized net %s found in net %s"
                          % (pname, vnet.name))
                    exit(-1)
        pl[i] = d
        l = "assign pl[%d] = " % i
        for j in range(137, 99, -1):
            if d & (1 << j):
                l = l + "p[%d] | " % j
        for j in range(99, 9, -1):
            if d & (1 << j):
                l = l + "p[%d]  | " % j
        for j in range(9, -1, -1):
            if d & (1 << j):
                l = l + "p[%d]   | " % j
        l = l[:-3]
        l = l.strip()
        print("%s;" % l)

    print("Microaddress dependency (amax=%d)" % amax)
    for i in range(amax):

        l = ''
        for j in range(138):
            if j in ma[i]:
                l += '*'
            else:
                l += '-'
        if '*' not in l:
            continue
        print("%02X: %s" % (i, l))
    for i in range(amax):
        l = ''
        for k in (16, 14, 12, 10, 8, 6, 4, 2, 0, -1, -1,
                  24, 23, 22, 21, 20, 19, 18, 17, -1,
                  15, 13, 11, 9, 7, 5, 3, 1):
            if k < 0:
                l += ' '
                continue
            c = '-'
            for j in range(138):
                if ((1 << j) & pl[k]) and (j in ma[i]):
                    c = '*'
                    break
            l += c
        if '*' not in l:
            continue
        print("%02X: %s" % (i, l))


def dc303_pdata(plink):
    pnet = netlist.get(plink, None)
    if pnet is None:
        print("Net %s not found in netlist" % plink)
        exit(-1)
    data = 0
    for t in pnet.nodes:
        nodes = pnet.nodes[t]
        cmp = cmplist[t]
        if len(nodes) != 1:
            print("Net %s has invalid attachment %s" % (plink, t))
            exit(-1)
        if nodes[0] != 2:
            continue
        if cmp.pins[1] != "GND":
            print("Net %s has invalid attachment %s" % (plink, t))
            exit(-1)
        l = cmp.pins[3]
        if not re.fullmatch(r"PL\d{1,3}", l):
            print("Net %s has invalid attachment %s, %s" % (plink, t, l))
            exit(-1)
        data |= 1 << int(l[2:])
    return data


def dc303_insrom(addr, vect, nsh, verb):
    na = 0
    for i in range(9):
        if vect & (1 << (i * 8 + nsh)):
            na |= 1 << i
    mc = 0
    for i in range(9):
        if vect & (1 << (i * 8 + 4 + nsh)):
            mc |= 1 << i
    for i in range(9, 16):
        if vect & (1 << (i * 4 + 36 + nsh)):
            mc |= 1 << i
    data = ~mc & 0xFFFF | (~na & 0x1FF) << 16
    if addr < 0x200:
        romlist[addr] = data
        if verb:
            print("rom %03X:%07X" % (addr, data))
    # move addresses AXT=1 to the zero ROM page
    # range [76..7F] is assigned from AXT = 1
    # range [70..75] is duplicated from AXT = 0
    if (addr & DC303_AX) >= DC303_AX:
        if addr >= 0x200 or (addr & 0x00F) < 6:
            xadr = addr & 0xF | (addr >> 3) & 0x30
            romlist[xadr] = data
            if verb:
                print("axt %03X:%07X" % (xadr, data))
    return


def dc303_outrom(verb):
    print('DEPTH = 512;\n'
          'WIDTH = 25;\n'
          'ADDRESS_RADIX = HEX;\n'
          'DATA_RADIX = HEX;\n'
          'CONTENT BEGIN')
    for addr in range(len(romlist)):
        data = romlist[addr]
        if data >= 0:
            print('%03X: %07X;' % (addr, data))
    print('END;')
    return


def proc_303_rom(verb):
    print("Decoding ROM matrix ...")
    for i in range(138):
        vlink = "P%d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)

        # gather mask for Pn-products for Hn/~Hn and In/~In
        seta = 0
        clra = 0
        data = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            cmp = cmplist[t]
            if len(nodes) != 1:
                print("Net %s has invalid attachment %s" % (vlink, t))
                exit(-1)
            if nodes[0] == 3:
                l = cmp.pins[2]
                if re.fullmatch(r"A[0-8]", l):
                    clra |= 1 << int(l[1:])
                    continue
                if l == "AX":
                    clra |= 1 << 9
                    continue
                if re.fullmatch(r"~A[0-8]", l):
                    seta |= 1 << int(l[2:])
                    continue
                if l == "~AX":
                    seta |= 1 << 9
                    continue
                if (re.fullmatch(r"H[0-6]", l) or
                    re.fullmatch(r"~H[0-6]", l) or
                    re.fullmatch(r"I\d{1,2}", l) or
                    re.fullmatch(r"~I\d{1,2}", l)):
                    continue
            if nodes[0] == 1 and cmp.pins[2] == "CLK1":
                continue
            if nodes[0] == 1 and cmp.pins[2] == "~PSTB":
                cmp = comp_by_pin(netlist[cmp.pins[3]], 2)
                if cmp is None or cmp.pins[1] != "~CLK":
                    print("Net %s has unrecognized attachment %s" % (vlink, t))
                    exit(-1)
                plink = cmp.pins[3]
                if verb:
                    print("2: %s %s %s" % (vlink, cmp.name, plink))
                data |= dc303_pdata(plink)
                continue
            if nodes[0] == 2 and cmp.pins[3] == "+12V":
                cmp = comp_by_pin(netlist[cmp.pins[1]], 3)
                if cmp is None or cmp.pins[2] != "~PSTB":
                    print("Net %s has unrecognized attachment %s" % (vlink, t))
                    exit(-1)
                cmp = comp_by_pin(netlist[cmp.pins[1]], 2)
                if cmp is None or cmp.pins[3] != "~CLK":
                    print("Net %s has unrecognized attachment %s" % (vlink, t))
                    exit(-1)
                plink = cmp.pins[1]
                if verb:
                    print("3: %s %s %s" % (vlink, cmp.name, plink))
                data |= dc303_pdata(plink)
                continue
            print("Net %s has unrecognized attachment %s" % (vlink, t))
            exit(-1)

        if seta & clra or seta >= (1 << 10) or clra >= (1 << 10):
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)
        mask = seta | clra
        addr = seta
        if mask != 0x27F and mask != 0x07F:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)
        if mask == 0x3FF and (addr & DC303_AX) < DC303_AX:
            print("Net: %s high AX address %03X %03X error"
                  % (vnet.name, seta, clra))
            exit(-1)
        if verb:
            print("@ %03X:%025X %s" % (addr, data, vlink))
        dc303_insrom(addr | (1 << 7), data, 2, verb)  # check for page 1/2
        dc303_insrom(addr | (2 << 7), data, 1, verb)  # swap on schematics
        dc303_insrom(addr | (3 << 7), data, 3, verb)
    dc303_outrom(verb)


def proc_302_ids(verb):
    print("Decoding ID matrix ...")
    for i in range(70):
        # ID29 is missing in the schematics
        if i == 29:
            continue
        vlink = "ID%d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)

        # gather mask for Pn-products for Hn/~Hn and In/~In
        seta = 0
        clra = 0
        xlst = []
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if re.fullmatch(r"I\d{1,2}", l):
                    ti = int(l[1:])
                    if 8 <= ti <= 15:
                        clra |= 1 << ti
                        continue
                    print("Net: %s opcode bit %d error" % (vnet.name, ti))
                    exit(-1)
                if re.fullmatch(r"~I\d{1,2}", l):
                    ti = int(l[2:])
                    if 8 <= ti <= 15:
                        seta |= 1 << ti
                        continue
                    print("Net: %s opcode bit %d error" % (vnet.name, ti))
                    exit(-1)
                xlst.append(l)

        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)

        # convert mask to string like "000111xxxx"
        l = ""
        for j in range(15, 7, -1):
            if seta & (1 << j):
                l += "1"
                continue
            if clra & (1 << j):
                l += "0"
                continue
            l += "x"
        if len(xlst):
            xl = ", %s" % xlst
        else:
            xl = ""
        print("%s: %04X %04X -> %s%s" % (vlink, seta, clra, l, xl))
    return


def proc_vm3(verb):
    plm = [[], [], [], [], [], [], [], [], [], [],
           [], [], [], [], [], [], [], [], [], [],
           [], [], [], [], [], [], [], [], [], [],
           [], [], [], [], [], [], [], []]

    for i in range(285):
        vlink = "MLINK_%03d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)

        # gather mask for Pn-products for Mn/~Mn
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            cmp = cmplist[t]
            if len(nodes) != 1:
                print("Net %s has invalid attachment %s" % (vlink, t))
                exit(-1)
            l = cmp.pins[2]
            if nodes[0] == 3:
                if re.fullmatch(r"M\d{1,2}", l):
                    clra |= 1 << int(l[1:])
                    continue
                if re.fullmatch(r"~M\d{1,2}", l):
                    seta |= 1 << int(l[2:])
                    continue
                if l == "~PLR_LAT":
                    continue
            if nodes[0] == 1:
                if l == "~PLM_EN":
                    continue
            print("Net %s has unrecognized attachment %s, %s, %d" % (vlink, t, l, nodes[0]))
            exit(-1)

        if seta & clra:
            print("Net: %s bitmask %05X %05X error" % (vnet.name, seta, clra))
            exit(-1)

        # convert mask to string like "000111xxxx"
        l = ""
        for j in range(22, -1, -1):
            if seta & (1 << j):
                l += "1"
                continue
            if clra & (1 << j):
                l += "0"
                continue
            l += "x"
        print("assign p[%d] = cmp({dc, mx, ma}, {14'b%s, 1'b%s, 8'b%s});" %
              (i, l[0:14], l[14:15], l[15:]))

        # find product output net
        vcmp = comp_by_pin(vnet, 3, type="FET-N")
        if vcmp is None:
            print("No pull-up component found in net %s" % vnet.name)
            exit(-1)
        if netlist[vcmp.pins[2]].name != "~PLR_LAT":
            print("No PLR_LAT on tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[1]]
        if verb:
            print(vnet.name, vnet.nodes, pnet.name)

        vcmp = comp_by_pin(pnet, 2)
        if vcmp is None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        if netlist[vcmp.pins[3]].name != "PLR_LAT":
            print("No PLR_LAT on tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[1]]
        if pnet.name != ("P%d" % i):
            print("Mismatch between net %s and P%d" % (vnet.name, i))
            exit(-1)

        # gather impacted PLD outputs
        for t in pnet.nodes:
            nodes = pnet.nodes[t]
            vcmp = cmplist[t]
            l = netlist[vcmp.pins[3]].name
            if l == "PLR_LAT" or l == pnet.name:
                continue
            if re.fullmatch(r"PL\d{1,2}", l):
                plm[int(l[2:])].append(i)
                continue
            print("Unrecognized net %s found in net %s" % (l, vnet.name))
            exit(-1)

    # print matrix outputs
    for i in range(38):
        l = "assign pl[%d] = " % i
        plm[i].sort(reverse=True)
        for p in plm[i]:
            if p < 10:
                l = l + "| p[%d]   " % p
            elif p < 100:
                l = l + "| p[%d]  " % p
            else:
                l = l + "| p[%d] " % p
        print("%s;" % l)


def proc_vm3b(verb):
    for i in range(17):
        vlink = "BLINK_%02d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)

        # gather mask for Pn-products for BIn/~BIn
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            cmp = cmplist[t]
            if len(nodes) != 1:
                print("Net %s has invalid attachment %s" % (vlink, t))
                exit(-1)
            l = cmp.pins[2]
            if nodes[0] == 3:
                if re.fullmatch(r"BRI\d{1}", l):
                    clra |= 1 << int(l[3:])
                    continue
                if re.fullmatch(r"~BRI\d{1}", l):
                    seta |= 1 << int(l[4:])
                    continue

        if seta & clra:
            print("Net: %s bitmask %02X %02X error" % (vnet.name, seta, clra))
            exit(-1)

        # convert mask to string like "000111xxxx"
        l = ""
        for j in range(7, -1, -1):
            if seta & (1 << j):
                l += "1"
                continue
            if clra & (1 << j):
                l += "0"
                continue
            l += "x"
        print("assign p[%d]  = cmp(br, 8'b%s);" % (i, l))


def proc_vm3c(verb):
    plc = [[], [], [], [], [], [], [], [], [],
           [], [], [], [], [], [], [], [], []]

    for i in range(27):
        vlink = "CLINK%d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)

        # gather mask for Pn-products for ICn/~ICn
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            cmp = cmplist[t]
            if len(nodes) != 1:
                print("Net %s has invalid attachment %s" % (vlink, t))
                exit(-1)
            if nodes[0] == 3:
                l = cmp.pins[2]
                if re.fullmatch(r"IC[0-6]", l):
                    clra |= 1 << int(l[2:])
                    continue
                if re.fullmatch(r"~IC[0-6]", l):
                    seta |= 1 << int(l[3:])
                    continue
                if l == "PLM20":
                    clra |= 1 << 7
                    continue
                if l == "~PLM20":
                    seta |= 1 << 7
                    continue
                if l == "PLM21":
                    clra |= 1 << 8
                    continue
                if l == "~PLM21":
                    seta |= 1 << 8
                    continue
                if l == "PLM26":
                    clra |= 1 << 9
                    continue
                if l == "~PLM26":
                    seta |= 1 << 9
                    continue
                if l == "PLM33":
                    clra |= 1 << 10
                    continue
                if l == "~PLM33":
                    seta |= 1 << 10
                    continue
                print("Unrecognized net %s found in net %s" % (l, vnet.name))
                exit(-1)

            if nodes[0] == 2:
                l = cmp.pins[3]
                if l == "+5V":
                    continue
                if re.fullmatch(r"OC\d{1,2}", l):
                    pl = int(l[2:])
                    plc[pl].append(i)
                    continue
                print("Unrecognized net %s found in net %s" % (l, vnet.name))
                exit(-1)

        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)

        # convert mask to string like "000111xxxx"
        l = ""
        for j in range(10, -1, -1):
            if seta & (1 << j):
                l += "1"
                continue
            if clra & (1 << j):
                l += "0"
                continue
            l += "x"
        print("assign p[%d]  = cmp(ic, 11'b%s);" % (i, l))

    # print matrix outputs
    for i in range(18):
        l = "assign pl[%d] = " % i
        plc[i].sort(reverse=True)
        for p in plc[i]:
            if p < 10:
                l = l + "| p[%d]  " % p
            else:
                l = l + "| p[%d] " % p
        print("%s;" % l)


def proc_vm3d(verb):
    pld = [[], [], [], [], [], [],
           [], [], [], [], [], [],
           [], [], [], [], [], [],
           [], [], [], []]

    for i in range(110):
        vlink = "DLINK_%02d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)

        # gather mask for Pn-products for BIn/~BIn
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            cmp = cmplist[t]
            if len(nodes) != 1:
                print("Net %s has invalid attachment %s" % (vlink, t))
                exit(-1)
            l = cmp.pins[2]
            if nodes[0] == 3:
                if re.fullmatch(r"BI\d{1,2}", l):
                    clra |= 1 << int(l[2:])
                    continue
                if re.fullmatch(r"~BI\d{1,2}", l):
                    seta |= 1 << int(l[3:])
                    continue
                if l == "~CLK":
                    continue
            if nodes[0] == 1:
                if l == "~DC_STB":
                    continue
            print("Net %s has unrecognized attachment %s" % (vlink, t))
            exit(-1)

        if seta & clra:
            print("Net: %s bitmask %05X %05X error" % (vnet.name, seta, clra))
            exit(-1)

        # convert mask to string like "000111xxxx"
        l = ""
        for j in range(17, -1, -1):
            if seta & (1 << j):
                l += "1"
                continue
            if clra & (1 << j):
                l += "0"
                continue
            l += "x"
        print("assign p[%d]  = cmp({ins, fpp, ir}, {1'b%s, 1'b%s, 16'b%s});" %
              (i, l[0:1], l[1:2], l[2:]))

        # find product output net
        vcmp = comp_by_pin(vnet, 1, type="FET-N")
        if vcmp is None:
            print("No pull-up component found in net %s" % vnet.name)
            exit(-1)
        if netlist[vcmp.pins[3]].name != "+5V":
            print("No +5V on tranceiving component found in net %s" % vnet.name)
            exit(-1)
        if netlist[vcmp.pins[2]].name != "~DC_STB":
            print("No ~DC_STB on tranceiving component found in net %s" % vnet.name)
            exit(-1)

        vcmp = comp_by_pin(vnet, 3, type="FET-N")
        if vcmp is None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        if netlist[vcmp.pins[2]].name != "~CLK":
            print("No ~CLK on tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[1]]
        if verb:
            print(vnet.name, vnet.nodes, pnet.name)

        vcmp = comp_by_pin(pnet, 2)
        if vcmp is None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        if netlist[vcmp.pins[3]].name != "DC_STBC":
            print("No DC_STBC on tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[1]]

        # gather impacted PLD outputs
        for t in pnet.nodes:
            nodes = pnet.nodes[t]
            vcmp = cmplist[t]
            l = netlist[vcmp.pins[3]].name
            if l == "DC_STBC" or l == pnet.name:
                continue
            if re.fullmatch(r"PLD\d{1,2}", l):
                pl = int(l[3:])
                pld[pl].append(i)
                continue
            print("Unrecognized net %s found in net %s" % (l, vnet.name))
            exit(-1)

    # print matrix outputs
    for i in range(22):
        l = "assign dc[%d] = " % i
        pld[i].sort(reverse=True)
        for p in pld[i]:
            if p < 10:
                l = l + "| p[%d]   " % p
            elif p < 100:
                l = l + "| p[%d]  " % p
            else:
                l = l + "| p[%d] " % p

        print("%s;" % l)


def proc_vm3i(verb):
    for i in range(11):
        vlink = "IMO%d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)

        # gather mask for Pn-products for IMn/~IMn
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            cmp = cmplist[t]
            if len(nodes) != 1:
                print("Net %s has invalid attachment %s" % (vlink, t))
                exit(-1)
            l = cmp.pins[2]
            if nodes[0] == 3:
                if re.fullmatch(r"IM\d{1,2}", l):
                    clra |= 1 << int(l[2:])
                    continue
                if re.fullmatch(r"~IM\d{1,2}", l):
                    seta |= 1 << int(l[3:])
                    continue
                if l == "IM_DIS":
                    clra |= 1 << 11

        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)

        # convert mask to string like "000111xxxx"
        l = ""
        for j in range(11, -1, -1):
            if seta & (1 << j):
                l += "1"
                continue
            if clra & (1 << j):
                l += "0"
                continue
            l += "x"
        print("assign p[%d]  = cmp(rq, 12'b%s);" % (i, l))


def proc_vm3f(verb):
    for i in range(24):
        vlink = "AL%d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)

        # gather mask for Pn-products for IAn/~IAn
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            cmp = cmplist[t]
            if len(nodes) != 1:
                print("Net %s has invalid attachment %s" % (vlink, t))
                exit(-1)
            l = cmp.pins[2]
            if nodes[0] == 3:
                if re.fullmatch(r"IA\d{1,2}", l):
                    clra |= 1 << int(l[2:])
                    continue
                if re.fullmatch(r"~IA\d{1,2}", l):
                    seta |= 1 << int(l[3:])
                    continue

        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)

        # convert mask to string like "000111xxxx"
        l = ""
        for j in range(13, -1, -1):
            if seta & (1 << j):
                l += "1"
                continue
            if clra & (1 << j):
                l += "0"
                continue
            l += "x"
        print("assign p[%d]  = cmp(cf, 14'b%s);" % (i, l))


def proc_vm3v(verb):
    for i in range(18):
        vlink = "BLINK%d" % i
        vnet = netlist.get(vlink, None)
        if vnet is None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)

        # gather mask for Pn-products for IBn/~IBn
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            cmp = cmplist[t]
            if len(nodes) != 1:
                print("Net %s has invalid attachment %s" % (vlink, t))
                exit(-1)
            l = cmp.pins[2]
            if nodes[0] == 3:
                if re.fullmatch(r"IB\d{1,2}", l):
                    clra |= 1 << int(l[2:])
                    continue
                if re.fullmatch(r"~IB\d{1,2}", l):
                    seta |= 1 << int(l[3:])
                    continue

        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)

        # convert mask to string like "000111xxxx"
        l = ""
        for j in range(11, -1, -1):
            if seta & (1 << j):
                l += "1"
                continue
            if clra & (1 << j):
                l += "0"
                continue
            l += "x"
        print("assign p[%d]  = cmp(ib, 12'b%s);" % (i, l))


def proc_netlist(arch, verb):
    print("Processing netlist for arch: %s" % arch)

    if arch == "cp1611":
        proc_1611(verb)
        return

    if arch == "cp1621":
        proc_1621_12(verb)
        proc_1621_34(verb)
        proc_1621_mr(verb)
        return

    if arch == "dc302":
        proc_302_ids(verb)
        return

    if arch == "dc303":
        proc_303_pla(verb)
        proc_303_rom(verb)
        return

    if arch == "vm3":
        proc_vm3(verb)
        return

    if arch == "vm3b":
        proc_vm3b(verb)
        return

    if arch == "vm3c":
        proc_vm3c(verb)
        return

    if arch == "vm3d":
        proc_vm3d(verb)
        return

    if arch == "vm3i":
        proc_vm3i(verb)
        return

    if arch == "vm3f":
        proc_vm3f(verb)
        return

    if arch == "vm3v":
        proc_vm3v(verb)
        return

    print("Unsupported arch: %s" % arch)
    exit(-1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("netfile",
                        type=argparse.FileType('r'),
                        help="input netlist file in PCAD-2004 ASCII format")
    parser.add_argument("--arch",
                        choices=["cp1611", "cp1621", "dc302", "dc303",
                                 "vm3", "vm3b", "vm3c",
                                 "vm3d", "vm3i", "vm3f", "vm3v"],
                        help="architecture used to translate the matrix",
                        default="vm3")
    parser.add_argument("--verbose",
                        action="store_true",
                        help="architecture used to translate the matrix")
    args = parser.parse_args()
    read_netlist(args.netfile, args.verbose)
    proc_netlist(args.arch, args.verbose)

    args.netfile.close()
    exit(0)
