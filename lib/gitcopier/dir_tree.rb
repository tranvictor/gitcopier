module Gitcopier
  class DirTree
    def initialize(root_path, files)
      @root = DirTreeNode.new "/"
      files.each do |line|
        _, file = line.split("\t")
        add_file(file)
      end
    end

    def travel(&block)
      raise ArgumentError if !block_given?
      visit(@root, block)
    end

    def visit(node, block)
      instruction = block.call(node.path)
      if instruction.nil?
        node.children.each do |name, child|
          visit(child, block)
        end
      end
    end

    private
    def add_file(file)
      is_dir = file.end_with? '/'
      parts = file.split('/')
      current_node = @root
      part_size = parts.size
      parts.each_with_index do |part, index|
        child = current_node.get_child(part)
        path = current_node.path + part
        # unless the part is the last part and the file is not a dir
        unless index + 1 == part_size && !is_dir
          path = path + '/'
        end
        unless child
          child = current_node.add_child(part, path)
        end
        current_node = child
      end
    end
  end

  class DirTreeNode
    attr_accessor :path, :type, :children

    def initialize(path)
      @path = path
      @type = path.end_with?('/') ? 'dir' : 'file'
      @children = {}
    end

    def get_child(name)
      @children[name]
    end

    # add or replace a child with given name and path
    def add_child(name, path)
      child = DirTreeNode.new(path)
      @children[name] = child
      return child
    end
  end
end
