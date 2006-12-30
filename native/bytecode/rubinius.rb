require 'bytecode/assembler'

module Bytecode
  class MethodDescription
    
    def to_cmethod
      asm = Bytecode::Assembler.new(@literals, @name)
      begin
        stream = asm.assemble @assembly
      rescue Object => e
        raise "Unable to assemble #{@name} in #{@file}. #{e.message}"
      end
      
      enc = Bytecode::InstructionEncoder.new
      bc = enc.encode_stream stream
      lcls = asm.number_of_locals
      
      cmeth = CompiledMethod.new.from_string bc.data, lcls, @required
      cmeth.exceptions = asm.exceptions_as_tuple

      if @primitive.kind_of? Symbol
        idx = CPU::Primitives.name_to_index(@primitive)
        begin
          cmeth.primitive = RObject.wrap(idx)
        rescue Object
          raise ArgumentError, "Unknown primitive '#{@primitive}'"
        end
      elsif @primitive
        cmeth.primitive = @primitive
      end

      cmeth.literals = encode_literals
      if @file
        # Log.info "Method #{@name} is contained in #{@file}."
        cmeth.file = @file.to_sym
      else
        # Log.info "Method #{@name} is contained in an unknown place."
        cmeth.file = nil
      end
      
      if @name
        cmeth.name = @name.to_sym
      end
      
      cmeth.lines = asm.lines_as_tuple
      cmeth.path = encode_path()
      return cmeth
    end

    def encode_path
      tup = Tuple.new(@path.size)
      i = 0
      @path.each do |pth|
        out = pth.to_sym
        tup.put i, out
        i += 1
      end
      
      return tup
    end
    
    def encode_literals
      tup = Tuple.new(@literals.size)
      i = 0
      lits = @literals
      # puts " => literals: #{lits.inspect}"
      lits.each do |lit|
        tup.put i, lit
        i += 1
      end
      
      return tup
    end
  end
  
  class Assembler
    def exceptions_as_tuple
      return nil if @exceptions.empty?
      excs = sorted_exceptions()
      tuple_of_int_tuples(excs)
    end
    
    def tuple_of_int_tuples(excs)
      exctup = Tuple.new(excs.size)
      i = 0
      excs.each do |ary|
        tup = Tuple.new(3)
        tup.put 0, ary[0]
        tup.put 1, ary[1]
        tup.put 2, ary[2]
        exctup.put i, tup
        i += 1
      end
      return exctup
    end
    
    def tuple_of_syms(ary)
      tup = Tuple.new(ary.size)
      i = 0
      ary.each do |t|
        sym = t.to_sym
        tup.put i, sym
        i += 1
      end
      return tup
    end
    
    def into_method
      cm = Rubinius::CompiledMethod.from_string(bytecodes, @locals.size)
      if @primitive
        cm.primitive = RObject.wrap(@primitive)
      end
      cm.literals = literals_as_tuple()
      cm.arguments = arguments_as_tuple()
      cm.exceptions = exceptions_as_tuple()
      cm.lines = lines_as_tuple()
      return cm
    end
    
    def primitive_to_index(sym)
      idx = CPU::Primitives.name_to_index(sym)
    end
  end
end