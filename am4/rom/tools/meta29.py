#!/usr/bin/python3
#
# Meta-assembler for the Am2900 bit-slice based processors.
# Copyright (c) 2020 Viacheslav Ovsiienko <1801BM1@gmail.com>
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
#
import os
import re
import sys
import time
import argparse

MIN_LC = 0x0000
MAX_LC = 0x1000
EXP_SF = 'BDEHQ'
EXP_SFX = EXP_SF + 'X'

def zhex(value, width):
    s = hex(value)[2:].upper()
    if width == 0:
        return s
    return s.rjust((width + 3) // 4, '0')


class Mib(object):
    ''' Microcode Bit Field '''
    def __init__(self, value, xmask = 0, width = 0):
        self.v = value & ~xmask # value
        self.x = xmask          # ignore mask
        self.w = width          # width

    def __str__(self):
        line = zhex(self.v, self.w)
        if self.w or self.x:
            line += ' [%d' % self.w
            if self.x:
                line += ', ' + zhex(self.x, self.w)
            line += ']'
        return line

    def __int__(self):          # convert to integer
        if self.x:
            raise SyntaxError("unary integer on undefined mib: %s" % self)
        return self.v

    def __msk__(self):          # masking
        if self.w:
            mask = (1 << self.w) - 1
            self.v &= mask
            self.x &= mask
        return self

    def __pos__(self):          # unary plus
        if self.x:
            raise SyntaxError("unary plus on undefined mib: %s" % self)
        return Mib(self.v, self.x, self.w)

    def __neg__(self):          # unary minus
        if self.x:
            raise SyntaxError("unary minus on undefined mib: %s" % self)
        r = Mib(self.v, self.x, self.w)
        r.v = -r.v
        r.__msk__()
        if r.v == 0 and self.v:
            raise SyntaxError("unary minus overflow: %s" % self)
        return r

    def __invert__(self):       # unary inversion
        r = Mib(self.v, self.x, self.w)
        r.v = ~r.v
        r.v &= ~r.x
        return r.__msk__()

    def __mul__(self, other):   # binary mul
        if self.x:
            raise SyntaxError("binary mul on undefined mib: %s" % self)
        if other.x:
            raise SyntaxError("binary mul on undefined mib: %s" % other)
        return Mib(self.v * other.v)

    def __floordiv__(self, other):  # binary div
        if self.x:
            raise SyntaxError("binary div on undefined mib: %s" % self)
        if other.x:
            raise SyntaxError("binary div on undefined mib: %s" % other)
        return Mib(self.v // other.v)

    def __add__(self, other):   # binary add
        if self.x:
            raise SyntaxError("binary add on undefined mib: %s" % self)
        if other.x:
            raise SyntaxError("binary add on undefined mib: %s" % other)
        r = Mib(self.v + other.v, 0, max(self.w, other.w))
        if r.w:
            s = r.v >> r.w
            if s and s != -1:
                raise SyntaxError("binary add overflow: %s" % r)
        return r.__msk__()

    def __sub__(self, other):   # binary sub
        if self.x:
            raise SyntaxError("binary sub on undefined mib: %s" % self)
        if other.x:
            raise SyntaxError("binary sub on undefined mib: %s" % other)
        r = Mib(self.v - other.v, 0, max(self.w, other.w))
        if r.w:
            s = r.v >> r.w
            if s and s != -1:
                raise SyntaxError("binary sub overflow: %s" % r)
        return r.__msk__()

    def __mod__(self, other):   # binary mod
        if self.x:
            raise SyntaxError("binary div on undefined mib: %s" % self)
        if other.x:
            raise SyntaxError("binary div on undefined mib: %s" % other)
        r = Mib(self.v % other.v)
        if r.w:
            s = r.v >> r.w
            if s and s != -1:
                raise SyntaxError("binary mod overflow: %s" % r)
        return r.__msk__()

    def __and__(self, other):   # binary and
        r = Mib(self.v & other.v, self.x | other.x, max(self.w, other.w))
        r.x &= (self.x | self.v) & (other.x | other.v)
        r.v &= ~r.x
        return r.__msk__()

    def __xor__(self, other):   # binary xor
        r = Mib(self.v ^ other.v, self.x | other.x, max(self.w, other.w))
        return r.__msk__()

    def __or__(self, other):    # binary or
        r = Mib(self.v | other.v, self.x | other.x, max(self.w, other.w))
        r.x &= (self.x | ~self.v) & (other.x | ~other.v)
        r.v &= ~r.x
        return r.__msk__()

    def __ovr__(self, other):   # binary overlay
        if self.w == 0 or other.w == 0 or self.w != other.w:
            raise SyntaxError("binary overlay failed: %s # %s" % (self, other))
        if (~self.x & ~other.x) & (self.v ^ other.v):
            raise SyntaxError("binary overlay conflict: %s # %s" %
                              (self, other))
        v = ~self.x & self.v | self.x & ~other.x & other.v
        r = Mib(v, self.x & other.x, self.w)
        return r.__msk__()

    def __eq__(self, other):
        return self.v == other.v and self.x == other.x and self.w == other.w

    def __ne__(self, other):
        return self.v != other.v or self.x != other.x or self.w != other.w


class Var(object):
    ''' Microcode Variable Field '''
    def __init__(self, value, width, attr = ''):
        self.a = attr           # V-field attributes :%~-$
        self.w = width          # bit width
        self.d = value          # default value or None
        if value is not None:
            assert(isinstance(value, Mib))
            assert(value.w == width)

    def __str__(self):
        if self.a == '':
            line = "[%d]" % self.w
        else:
            line = "[%d, '%s']" % (self.w, self.a)
        if self.d is not None:
            line += ", %s" % self.d
        return line

class Def(object):
    ''' Microcode Definition Object '''
    def __init__(self, lobj = []):
        self.l = lobj           # fiels list of Mibs and Vars
        self.w = 0              # resulting width
        for f in lobj:
            assert(isinstance(f, Mib) or isinstance(f, Var))
            assert(f.w)
            self.w += f.w


class Am29(object):
    ''' Assembler for AMD Am2900 Bit-Slice Microcode '''
    #
    # Compiled regular expressions
    #
    RE_VAR = re.compile(r'(?:^[0-9]+V[\:\%\$\~\-]*)')
    RE_OPCODE = re.compile(r'(?:[\.a-zA-Z$_][a-zA-Z0-9$_]*\s*)')
    RE_SYMBOL = re.compile(r'(?:[\.a-zA-Z$_][a-zA-Z0-9$_\.]*\s*=\s*)')
    RE_LABEL = re.compile(r'(?:[a-zA-Z0-9$_\.]+\s*:\s*)')
    RE_LOCAL = re.compile(r'(?:\d+\$)')

    #
    # Operations to calculate expressions
    #
    EXP_OPERS = {
        'U+': (10, lambda x: +x),           # unary plus
        'U-': (10, lambda x: -x),           # unary minus
        'U~': (9, lambda x: ~x),            # unary one's complement
        '*': (7, lambda x, y: x * y),       # binary mul
        '/': (7, lambda x, y: x // y),      # binary div
        '%': (7, lambda x, y: x % y),       # binary mod
        '+': (6, lambda x, y: x + y),       # binary add
        '-': (6, lambda x, y: x - y),       # binary sub
        '&': (5, lambda x, y: x & y),       # binary and
        '^': (4, lambda x, y: x ^ y),       # binary xor
        '|': (3, lambda x, y: x | y),       # binary or
        '#': (2, lambda x, y: x.__ovr__(y)) # binary overlay
    }
    EXP_UNA = '+-~'
    EXP_OPS = '+-~*/+-&^|#'
    EXP_ALL = '+-~*/+-&^|#()'

    def __init__(self):
        self.ps = 0             # pass number
        self.lc = 0             # location counter
        self.radx = 10          # default radix
        self.lnum = 0           # line number
        self.fnam = None        # source file name
        self.flst = None        # listing file name
        self.fend = 0           # .end directive found
        self.wcnt = 0           # warning counter
        self.ecnt = 0           # error counter
        self.elst = []          # line error list for listing
        self.efst = 0           # first error output
        self.bloc = {}          # local labels block
        self.cloc = {}          # current local block
        self.clin = {}          # local block line number
        self.radix = 8          # default radix
        self.width = 0          # microword width
        self.word = None        # word being constructed
        self.fcom = -1          # committed word address
        self.data = [-1] * MAX_LC
        self.symb = {}          # symbols list
        return

    #
    # Directive handlers
    #
    def dir_title(self, opcode):
        #
        # Ignore .title for compatibility
        #
        return

    def dir_radix(self, opcode):
        radx = self.eval_exp(opcode[1]).__int__()
        #
        # radix 16 is not supported to avoid digits and names
        # misinterpreting, i.e. DEAD0 might represent both
        #
        if radx not in (8, 10):
            raise SyntaxError("unsupported radix value '%d'" % radx)
        self.radx = radx
        return

    def dir_loc(self, opcode):
        loc = self.eval_exp(opcode[1]).__int__()
        #
        # Allow counter to get any value
        # Check will happen on actual usage
        #
        self.lc = loc
        return

    def dir_align(self, opcode):
        pw2 = self.eval_exp(opcode[1]).__int__()
        mask = (1 << pw2) - 1
        if not MIN_LC <= mask < MAX_LC or pw2 >= 16:
            raise SyntaxError("aligment is out of range 0x%08X" % mask)
        self.lc += mask
        self.lc &= ~mask
        return

    def dir_word(self, opcode):
        word = self.eval_exp(opcode[1]).__int__()
        if self.width > 0 and word != self.width:
            raise SyntaxError("duplicated microcode word width definition")
        self.width = word
        return

    def dir_end(self, opcode):
        self.fend = 1
        return

    def dir_weak(self, opcode):
        if self.width <= 0:
            raise SyntaxError("word width undefined before 'weak'")
        opcode.pop(0)
        weak = self.gather_mib(opcode)
        if weak.w != self.width:
            raise SyntaxError("invalid 'weak' value width: %d" % weak.w)
        self.weak = weak
        return

    def dir_equ(self, opcode):
        name = opcode.pop(0)
        word = self.gather_mib(opcode)
        self.assign_symbol(name, word)
        return

    def dir_sub(self, opcode):
        if self.width <= 0:
            raise SyntaxError("word width undefined before 'sub'")
        name = opcode.pop(0)
        defs = self.gather_var(opcode)
        if defs.w > self.width:
            raise SyntaxError("'sub' word width is too large: %d" % defs.w)
        self.assign_symbol(name, defs)
        return

    def dir_def(self, opcode):
        if self.width <= 0:
            raise SyntaxError("word width undefined before 'def'")
        name = opcode.pop(0)
        defs = self.gather_var(opcode)
        if defs.w != self.width:
            raise SyntaxError("'def' word width is incorrect: %d" % defs.w)
        self.assign_symbol(name, defs)
        return

    DIR_OPS_ONE = {
        '.title': (dir_title, -1),  # .title "ignored title"
        '.radix': (dir_radix, 1),   # .radix 8./10.
        '.align': (dir_align, 1),   # .align 2
        '.word':  (dir_word, 1),    # .word 56
        '.weak':  (dir_weak, -1),   # .weak
        '.loc':   (dir_loc, 1),     # .loc
        '.org':   (dir_loc, 1),     # .org
        '.end':   (dir_end, 0)      # .end
    }
    DIR_OPS_TWO = {
        '.sub':   dir_sub,      # .sub
        '.def':   dir_def,      # .def
        '.equ':   dir_equ,      # .equ
    }

    def gather_mib(self, lst):
        if not lst:
            raise SyntaxError("empty mib fields list")
        r = self.eval_exp(lst[0])
        for f in lst[1:]:
            n = self.eval_exp(f)
            if n.w == 0:
                raise SyntaxError("adding integer from the list")
            r.v = (r.v << n.w) | n.v
            r.x = (r.x << n.w) | n.x
            r.w += n.w
        return r

    #
    # Variable field format [nnn]V[:%~-$][BQDEHX][ddddd]
    #
    def attempt_var(self, token):
        match = Am29.RE_VAR.match(token)
        if match is None:
            return 0
        ix = token.find('V')
        assert(ix > 0)
        try:
            value = None
            width = int(token[:ix], base=10)
            attr = ''
            ix += 1
            if ix < len(token):
                for s in token[ix:]:
                    if s in ':%~-$':
                        attr += s
                        ix += 1
                    else:
                        break
            if ix < len(token):
                if token[ix] not in EXP_SFX:
                    raise SyntaxError("invalid variable field '%s'" % token)
                line = ('%d' % width) + token[ix:]
                value = self.eval_exp(line)
            var = Var(value, width, attr)
            return var
        except ValueError:
            raise SyntaxError("invalid variable field length '%s'" % token)

    def gather_var(self, lst):
        if not lst:
            raise SyntaxError("empty def/sub fields list")
        r = []
        for f in lst:
            #
            # First try to recognize named subfield
            #
            sub = self.symb.get(f)
            if isinstance(sub, Def):
                r += sub.l
                continue
            #
            # Then try to recognize variable field
            #
            n = self.attempt_var(f)
            if not isinstance(n, Var):
                n = self.eval_exp(f)
            r.append(n)
        return Def(r)

    #
    # Calculates the expression in Polish Reverse Notation
    #
    def calc_exp(self, polish):
        stack = []
        for token in polish:
            if not isinstance(token, Mib) and token in Am29.EXP_OPERS:
                if token[0] == 'U':
                    x = stack.pop()
                    stack.append(Am29.EXP_OPERS[token][1](x))
                else:
                    y, x = stack.pop(), stack.pop()
                    stack.append(Am29.EXP_OPERS[token][1](x, y))
            else:
                stack.append(token)
        if not stack:
            raise SyntaxError("invalid integer expression (empty)")
        return stack[0]

    #
    # Converts the infix expression to Polish Reverse Notation
    #
    def polish_exp(self, string):
        stack = []
        for token in string:
            if isinstance(token, Mib):
                yield token
                continue
            if token in Am29.EXP_OPERS:
                while (stack and
                        not isinstance(stack[-1], Mib) and
                        stack[-1] != "(" and
                        Am29.EXP_OPERS[token][0] <=
                        Am29.EXP_OPERS[stack[-1]][0]):
                    yield stack.pop()
                stack.append(token)
            elif token == ")":
                while stack:
                    x = stack.pop()
                    if x == "(":
                        break
                    yield x
            elif token == "(":
                stack.append(token)
            else:
                yield token
        while stack:
            yield stack.pop()

    #
    # Token generator wrapper, replaces [+-~] with unary tags
    #
    def subst_unary(self, string):
        prev = True
        for token in string:
            if type(token) is not str:
                prev = False
                yield token
                continue
            if token in Am29.EXP_UNA and prev:
                yield 'U' + token
                continue
            prev = token in Am29.EXP_OPS or token == '('
            yield token

    #
    # Token generator helper, replaces the numbers with actual integers
    #
    def subst_number(self, token):
        try:
            lt = len(token)
            if token[0] == '0':
                if lt > 1:
                    if token[1] in 'xX':
                        return int(token[2:], base=16)
                    if token[1] in 'bB':
                        return int(token[2:], base=2)
                    if token[-1] == '.':
                        return int(token[:-1], base=10)
                    return int(token, base=8)
            if token[-1] == '.':
                return int(token[:-1], base=10)
            return int(token, self.radx)
        except ValueError:
            raise SyntaxError("invalid integer expression '%s'" % token)

    #
    # Token generator helper, replaces the local labels nnnn$
    #
    def subst_local(self, token):
        if not token[:-1].isdigit():
            raise SyntaxError("invalid local identifier '%s'" % token)
        label = self.cloc.get(token)
        if label is None:
            raise SyntaxError("undefined local identifier '%s'" % token)
        return label

    #
    # Token generator helper, generates mibs from the text
    # [dddd][BQDEHX]#[nXnXxx]
    #
    def subst_mib(self, token, ix):
        try:
            mib = Mib(0)
            radix = token[ix-1]
            if radix == 'B':
                mul = 2
                dtw = 1
            elif radix == 'Q':
                mul = 8
                dtw = 3
            elif radix == 'D':
                mul = 10
                dtw = 4
            elif radix == 'H':
                mul = 16
                dtw = 4
            elif radix == 'X':
                mib.w = int(token[:ix-1], base=10)
                mib.x = (1 << mib.w) - 1
                return mib
            elif radix == 'E':
                exp = self.symb.get(token[ix+1:])
                if not isinstance(exp, Mib):
                    raise SyntaxError(
                        "invalid field expression '%s'" % token)
                if ix <= 1:
                    raise SyntaxError("E mib expression requires "
                                      "explicit length '%s'" % token)
                mib.w = int(token[:ix-1], base=10)
                if (exp.w >> mib.w) and (exp.x >> mib.w):
                    raise SyntaxError("truncation in E mib expression "
                                      "'%s'" % token)
                mib.v = exp.w
                mib.x = exp.x
                return mib
            else:
                assert(False)
            for s in token[ix+1:]:
                mib.v *= mul
                mib.x <<= dtw
                mib.w += dtw
                digit = s.upper()
                if digit == 'X':
                    if radix == 'D':
                        raise SyntaxError(
                            "'X' in decimal field expression '%s'" % token)
                    mib.x |= (1 << dtw) - 1
                    continue
                if 'A' <= digit <= 'F':
                    digit = ord(digit) - ord('A') + 10
                else:
                    if '0' <= digit <= '9':
                        digit = ord(digit) - ord('0')
                    else:
                        raise ValueError()
                if digit >= mul:
                    raise ValueError()
                mib.v += digit
            if ix > 1:
                mib.w = int(token[:ix-1], base=10)
                if mib.v >> mib.w:
                    raise SyntaxError("field expression truncation '%s'"
                                      % token)
            return mib
        except ValueError:
            raise SyntaxError("invalid field expression '%s'" % token)
    #
    # Token generator wrapper, replaces the symbols with actual Mibs
    #
    def subst_symbol(self, string):
        for token in string:
            if token in Am29.EXP_ALL:
                yield token
            elif token[0] in '0123456789':
                if token[-1] == '$':
                    yield Mib(self.subst_local(token))
                    continue
                ix = token.find('#')
                if ix > 0 and token[ix-1] in EXP_SF:
                    yield self.subst_mib(token, ix)
                    continue
                ix = token.find('X')
                if ix > 0 and token[0:ix].isdigit:
                    # check for 0xHHHH
                    if ix != 1 or token[0] != '0':
                        yield self.subst_mib(token, ix + 1)
                        continue
                yield Mib(self.subst_number(token))
            elif len(token) >= 2 and token[1] == '#' and token[0] in EXP_SF:
                    yield self.subst_mib(token, 1)
            elif token[0] == "'" and token[-1] == "'" and len(token) == 3:
                yield Mib(ord(token[1]))
            elif token == '.':
                yield Mib(self.lc)
            else:
                value = self.symb.get(token)
                if value is None:
                    raise SyntaxError("undefined identifier '%s'" % token)
                if isinstance(value, Def):
                    continue
                if not isinstance(value, Mib):
                    value = Mib(value)
                yield value

    #
    # Source token generator parses the original line
    #
    def parse_exp(self, string):
        quota = False
        start = -1
        pos = -1
        for s in string:
            pos += 1
            if start < 0:
                if s in ' \t':
                    continue
                start = pos
            if s == "'":
                quota = not quota
                continue
            if quota:
                continue
            if s == ';':
                if start >= 0 and start != pos:
                    yield string[start:pos]
                start = -1
                break
            if s.isalnum() or s in '"$_.':
                continue
            if s == '#' and pos >= 1 and string[pos-1] in 'BQDEH':
                continue
            if start >= 0 and start != pos:
                yield string[start:pos]
            start = -1
            if s in Am29.EXP_ALL:
                yield s
                start = -1
                continue
            if s not in ' \t':
                raise SyntaxError("invalid expression '%s'" % s)
        if start >= 0:
            yield string[start:]

    #
    # Evaluate arithmetics expression, returns integer if succeeded,
    # otherwise throws SyntaxError with error message generated
    #
    def eval_exp(self, exp):
        value = self.calc_exp(                      # calculate polish
                  self.polish_exp(                  # convert to polish
                    self.subst_unary(               # convert unary
                      self.subst_symbol(            # subst symbols
                        self.parse_exp(exp)))))     # generate tokens
        return value

    def open_file(self, name, ext, mode):
        #
        # Add the default file name extension if needed
        #
        sname = os.path.splitext(name)
        if not sname[1]:
            name += '.' + ext
        self.fnam = name
        try:
            file = open(name, mode, -1, None, None)
        except OSError as err:
            raise RuntimeError(err)
        return file

    def close_file(self, file):
        if file is not None:
            file.close()
        return

    #
    # Prints the symbol list into listing
    #
    def final_dict(self, title, fl):
        maxl = 0
        nl = []
        for s in self.symb:
            nl.append(s)
            maxl = max(maxl, len(s))
        nl.sort()
        numl = len(nl)
        print("\n%s: %d entries" % (title, numl), file=fl)
        for i in range(numl):
            s = nl[i]
            v = self.symb[s]
            line = s.ljust(maxl + 2)
            if isinstance(v, int):
                line += "int  %s" % zhex(v, 32)
            elif isinstance(v, Mib):
                line += "mib  %s" % v
            elif isinstance(v, Def):
                line += "def  [%d]" % v.w
                for f in v.l:
                    line += "\n  "
                    if isinstance(f, Mib):
                        line += "mib  %s" % f
                    elif isinstance(f, Var):
                        line += "var  %s" % f
                    else:
                        assert(False)
            else:
                assert(False)
            print("%s" % line, file=fl)
        return
    #
    # Show final compilation statistics
    #
    def final_stat(self, flst):
        msg = '\nErrors: %d\nWarnings: %d\n' % (self.ecnt, self.wcnt)
        if self.ecnt or self.wcnt:
            print(msg, file=sys.stderr)
        if flst is not None and self.symb:
            self.final_dict("Symbol definitions", flst)
            print(msg, file=flst)
        return

    #
    # Store error information for the listing after the line
    #
    def log_error(self, emsg, ps=2):
        if ps in (0, self.ps):
            if self.efst == 0:
                print('', file=sys.stderr)
                self.efst = 1
            msg = '*** Error[%d]: %s' % (self.lnum, emsg)
            print(msg, file=sys.stderr)
            self.elst.append(msg)
            self.ecnt += 1
        return

    def log_warning(self, emsg, ps=2):
        if ps in (0, self.ps):
            if self.efst == 0:
                print('', file=sys.stderr)
                self.efst = 1
            msg = '*** Warning[%d]: %s' % (self.lnum, emsg)
            print(msg, file=sys.stderr)
            self.elst.append(msg)
            self.wcnt += 1
        return

    #
    # Process the local label block boundary
    #
    def local_block(self):
        if self.ps == 1:
            if self.cloc:
                self.bloc[self.clin] = self.cloc.copy()
            self.cloc = {}
        else:
            self.cloc = self.bloc.get(self.lnum, {})
        self.clin = self.lnum
        return

    #
    # Assign the local or generic label with local counter
    #
    def assign_label(self, label):
        match = Am29.RE_LOCAL.match(label)
        if match is not None:
            #
            # Local label processing
            #
            if self.ps == 1:
                if label in self.cloc:
                    msg = "label duplication '%s'" % label
                    self.log_error(msg, 0)
                    raise SyntaxError(msg)
                self.cloc[label] = self.lc
            else:
                if self.cloc.get(label, -1) != self.lc:
                    raise SyntaxError("label phase mismatch '%s'" % label)
        else:
            #
            # Generic label processing
            #
            if label == '.':
                raise SyntaxError("wrong location counter usage")
            label = label.upper()
            if label[0].isdigit():
                raise SyntaxError("label starts with digit  '%s'" % label)
            lc = self.symb.get(label)
            if self.ps == 1:
                if lc is not None:
                    msg = "label duplication '%s'" % label
                    self.log_error(msg, 0)
                    raise SyntaxError(msg)
                self.symb[label] = self.lc
            else:
                if not isinstance(lc, int):
                    raise SyntaxError("label type mismatch '%s'" % label)
                if lc != self.lc:
                    raise SyntaxError("label phase mismatch '%s': %s, %s" %
                                      (label, zhex(lc, 32), zhex(self.lc, 32)))
        return

    #
    # Assign the value to symbol in "symbol = value"
    #
    def assign_symbol(self, symbol, exp):
        symbol = symbol.upper()
        if isinstance(exp, str):
            value = self.eval_exp(exp)
        else:
            value = exp
        if symbol == '.':
            self.lc = value
            return
        qs = self.symb.get(symbol)
        if self.ps == 1:
            if qs is not None:
                msg = "symbol duplication '%s'" % symbol
                self.log_error(msg, 0)
                raise SyntaxError(msg)
            self.symb[symbol] = value
        else:
            if qs is None:
                self.symb[symbol] = value
            else:
                if type(qs) != type(value):
                    raise SyntaxError("symbol type phase mismatch '%s'" % symbol)
                if isinstance(qs, int):
                    if qs != value:
                        raise SyntaxError("symbol phase mismatch '%s': %d, %d"
                                          % (symbol, zhex(qs, 32),
                                            zhex(qs, value)))
                elif isinstance(qs, Mib):
                    if qs.v != value.v or qs.x != value.x or qs.w != value.w:
                        raise SyntaxError("mib symbol phase mismatch '%s': "
                                          "%s, %s" % (symbol, qs, value))
        return

    def attr_var(self, f, v):
        r = Mib(v.v, v.x, v.w)
        for a in f.a:
            if a in ':$':       # truncation
                if r.w > f.w or r.w == 0:
                    if (r.v >> f.w) and (r.v >> f.w) != -1:
                        raise SyntaxError("variable field truncation: "
                                          "%d, %s" % (f.w, zhex(r.v, r.w)))
                    r.w = f.w
                if a == '$' and r.w < f.w:
                    r.w = f.w
            elif a == '%':      # extension
                if r.w < f.w:
                    r.w = f.w
            elif a == '~':      # inversion
                r.v = ~r.v
                r.__msk__()
            elif a == '-':      # negation
                r.v = -r.w
                if (r.v >> f.w) and (r.v >> f.w) != -1:
                    raise SyntaxError("variable field truncation: "
                                      "%d, %s" % (f.w, zhex(r.v, r.w)))
            else:
                raise SyntaxError("unknown variable field attribute '%s'" % a)
        return r

    def do_defs(self, opcode, obj, cont):
        if self.ps == 1 and not cont:
            self.do_apply(None, 0)
        ix = 1
        lj = self.width
        for f in obj.l:
            if isinstance(f, Mib):
                value = f
            elif isinstance(f, Var):
                if ix >= len(opcode) or opcode[ix] == '':
                    if f.d is None:
                        raise SyntaxError("field requires explicit value")
                    value = f.d
                else:
                    value = self.eval_exp(opcode[ix])
                ix += 1
                if f.a != '':
                    value = self.attr_var(f, value)
            else:
                assert(False)
            assert(isinstance(value, Mib))
            if value.w == 0:
                raise SyntaxError("field requires value with length")
            if f.w != value.w:
                raise SyntaxError("field length mismatch: "
                                  "%d, %d" % (f.w, value.w))
            #
            # Apply value to the word being built
            #
            assert(value.w == f.w)
            if value.w > lj:
                raise SyntaxError("microcode word overflow")
            lj -= value.w
            self.do_apply(value, lj)
        if ix < len(opcode):
            self.log_warning("too many operands")
        return

    #
    # Field generator - splits on ',' accounting quotas, slashes, comments
    #
    def parse_gen(self, string):
        start = -1
        quota = 0
        slash = 0
        pos = -1
        for s in string:
            pos += 1
            if start < 0:
                if s in ' \t':
                    continue
                if s == ',':
                    yield ''
                    start = -1
                    quota = 0
                    slash = 0
                    continue
                if s == ';':
                    break
                start = pos
            if quota == 0:
                if s == ',':
                    yield string[start:pos]
                    start = -1
                    quota = 0
                    slash = 0
                    continue
                if s == ';':
                    if pos != start:
                        yield string[start:pos]
                    start = -1
                    break
                if s == "'":
                    quota = 1
                elif s == '"':
                    quota = 2
                continue
            if slash:
                slash = 0
                continue
            if s == '\\':
                slash = 1
                continue
            if quota == 1:
                if s == "'":
                    quota = 0
            else:
                if s == '"':
                    quota = 0
        if start >= 0:
            yield string[start:]

    #
    # Parse the optional parameters after opcode/directive
    #
    def parse_args(self, opcode, line):
        for field in self.parse_gen(line):
            field = field.strip(' \t')
            if field and field[0] not in '\'\"':
                field = field.upper()
            opcode.append(field)
        return opcode

    def do_opcode(self, opcode, cont):
        oc = opcode[0]
        obj = Am29.DIR_OPS_ONE.get(oc.lower())
        if obj is not None:
            narg = len(opcode) - 1
            if obj[1] >= 0 and narg < obj[1]:
                raise SyntaxError("not enough parameters for '%s'" % oc)
            if obj[1] >= 0 and narg > obj[1]:
                raise SyntaxError("too many directive parameters '%s'" % oc)
            obj[0](self, opcode)
            return
        #
        # Handle special case for concatenation on .equ/.def/.sub
        #
        if len(opcode) >= 2 and len(opcode[1]) >= 4:
            sec = opcode[1][0:4].lower()
            obj = Am29.DIR_OPS_TWO.get(sec)
            if obj is not None:
                opcode[1] = opcode[1][4:].strip(' \t')
                obj(self, opcode)
                return
        defs = self.symb.get(oc.upper())
        if isinstance(defs, Def):
            self.do_defs(opcode, defs, cont)
            return
        raise SyntaxError("invalid command or directive '%s'" % oc)

    def do_apply(self, data, base):
        if self.word is None:
            self.word = Mib(0, (1 << self.width) - 1, self.width)
        if data is None:
            return
        assert(0 <= base < self.width)
        assert(0 <= (base + data.w) <= self.width)
        x = (1 << self.width) - 1
        x &=  ~(((1 << data.w) - 1) << base)
        x |= data.x << base
        ovr = Mib(data.v << base, x, self.width)
        self.word = self.word.__ovr__(ovr)
        return
    #
    # Commit the constructed microcode word
    #
    def do_commit(self):
        if self.word is not None:
            if self.ps != 1 and self.weak is not None:
                x = ~self.weak.x & self.word.x
                v = self.weak.v & x
                x = ~x & ((1 << self.width) - 1)
                weak = Mib(v, x, self.width)
                self.do_apply(weak, 0)
            word = self.word
            self.word = None
            if self.width <= 0:
                raise SyntaxError("commit failed, undefined word width")
            addr = self.lc
            if not MIN_LC <= addr < MAX_LC:
                raise SyntaxError("Location is out of range '0x%04X'" % addr)
            if self.data[addr] >= 0 and self.data[addr] != word.v:
                raise SyntaxError("Location multiple commit '0x%04X'" % addr)
            if word.x != 0:
                word.v &= ~word.x
                word.x = 0
            if self.ps != 1:
                self.data[self.lc] = word.v
                self.fcom = self.lc
            self.lc += 1
        return

    #
    # Compile the single source line
    #
    def do_line(self, line):
        self.elst = []
        #
        # Skip empty line
        #
        if not line:
            self.do_commit()
            return
        #
        # Detect local label block boundary
        #
        if line[0] not in ' \t;0123456789#':
            self.local_block()
        line = line.strip(' \t')
        if not line:
            self.do_commit()
            return
        if line[0] == ';':
            return
        commit = line[0] != '#'
        #
        # Match on optional present label "labels:"
        #
        match = Am29.RE_LABEL.match(line)
        if match is not None:
            label = match.group().rstrip(' \t:')
            line = line[match.end():]
            self.assign_label(label)
            if not line:
                if commit:
                    self.do_commit()
                return
        if commit:
            self.do_commit()
        #
        # Match on variable assignment "var = exp"
        #
        match = Am29.RE_SYMBOL.match(line)
        if match is not None:
            label = match.group().rstrip(' \t=')
            line = line[match.end():]
            self.assign_symbol(label, line)
            return
        #
        # Get opcode continuation flag
        #
        cont = line[0] == '#'
        if cont:
            line = line.lstrip('# \t')
        #
        # Match on opcode definition or assembler directive
        #
        match = Am29.RE_OPCODE.match(line)
        if match is None:
            raise SyntaxError("syntax error")
        opcode = [match.group().rstrip(' \t')]
        line = line[match.end():]
        opcode = self.parse_args(opcode, line)
        self.do_opcode(opcode, cont)
        return

    def do_list(self, line):
        if self.flst is not None:
            if self.fcom >= 0:
                print("    %03X: %s" % (self.fcom,
                      zhex(self.data[self.fcom], self.width)), file=self.flst)
                self.fcom = -1
            print("%5d  %03X\t\t%s" %
                  (self.lnum, self.lc, line), file=self.flst)
            for emsg in self.elst:
                print("%s" % emsg, file=self.flst)
        return

    #
    # Set the pass number and reinit the parser
    #
    def set_pass(self, ps):
        self.ps = ps
        self.lc = 0
        self.width = 0
        self.ecnt = 0
        self.wcnt = 0
        self.lnum = 0
        self.clin = 0
        self.cloc = self.bloc.get(0, {})
        self.word = None
        self.fcom = -1
        return

    #
    # Process one source file
    #
    def do_assembly(self, fsrc, flst):
        self.flst = flst
        if self.ps == 2 and self.flst is not None:
            print('00000  Time: %s  ' % time.ctime(),
                  'File: %s\n' % self.fnam.upper(), file=self.flst)
        self.fend = 0
        for line in fsrc:
            self.lnum += 1
            line = line.strip('\r\n')
            try:
                self.do_line(line)
            except SyntaxError as err:
                self.log_error(err)

            if self.ps == 2 and self.flst is not None:
                self.do_list(line)
            if self.fend:
                break
        self.local_block()
        if self.fend == 0:
            self.elst = []
            self.log_warning("missing '.end' directive")
            if self.flst is not None:
                print('%s' % self.elst[0], file=self.flst)
        return

    def write_obj(self, fobj):
        if self.width <= 0:
            return
        msk = (1 << self.width) - 1
        lim = -1
        for i in range(MAX_LC):
            if self.data[i] >= 0:
                lim = i
        if lim < 0:
            return
        lim += 1
        print('DEPTH = %d;\n'
              'WIDTH = %d;\n'
              'ADDRESS_RADIX = HEX;\n'
              'DATA_RADIX = HEX;\n'
              'CONTENT BEGIN' % (lim, self.width), file=fobj)
        for i in range(lim):
            data = self.data[i]
            if data >= 0:
                print('%04X: %s;' %
                      (i, zhex(data & msk, self.width)), file=fobj)
        print('END;',  file=fobj)
        return


def createParser():
    p = argparse.ArgumentParser(
        description='Am2900 Microcode Meta Assembler, '
                    'Version 20.12a, (c) 1801BM1')
    p.add_argument('src', nargs='+',
                   help='input source file(s)', metavar='file [file ...]')
    p.add_argument('-l', '--lst', help='output listing file', metavar='file')
    p.add_argument('-o', '--obj', help='output object file', metavar='file')
    return p


def main():
    parser = createParser()
    params = parser.parse_args()

    try:
        asm = Am29()
        #
        # Check all source files existance
        #
        for src in params.src:
            fsrc = asm.open_file(src, 'mic', 'r')
            asm.close_file(fsrc)
        #
        # Do the first pass for all sources
        #
        asm.set_pass(1)
        for src in params.src:
            fsrc = asm.open_file(src, 'mic', 'r')
            asm.do_assembly(fsrc, None)
            asm.close_file(fsrc)
        #
        # Do the second pass with optional listing output
        #
        asm.set_pass(2)
        if params.lst is not None:
            flst = asm.open_file(params.lst, 'lst', 'w')
        else:
            flst = None
        for src in params.src:
            fsrc = asm.open_file(src, 'mic', 'r')
            asm.do_assembly(fsrc, flst)
            asm.close_file(fsrc)
        asm.final_stat(flst)
        asm.close_file(flst)
        #
        # Save the assembling results
        #
        if params.obj is not None and asm.ecnt == 0:
            fobj = asm.open_file(params.obj, 'mif', 'w')
            asm.write_obj(fobj)
            asm.close_file(fobj)
        if asm.ecnt or asm.wcnt:
            sys.exit(1)
        sys.exit(0)

    except RuntimeError as err:
        print('\nerror: %s' % err, file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
