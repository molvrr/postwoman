module Commands
  class Workbench < Base
    ALIASES = %w[wb].freeze
    DESCRIPTION = 'Access workbench, printing it. May be called alone or with args to modify it. Pairs set values.'.freeze
    ARGS = {
      subcommand: '[d]delete (followed by target key), [cp]copy (followed by target key and new key), [rn]rename (followed by target key and new name)',
      target_key: 'Used on (all) subcommands',
      second_arg: 'Only on subcommands [rename] and [copy]'
    }.freeze

    def execute
      subcommand = args[0]
      case subcommand
      when 'd'
        delete_subcommand
      when 'cp'
        copy_subcommand
      when 'rn'
        rename_subcommand
      when nil
      else
        puts "Invalid subcommand: '#{subcommand}'".yellow
      end

      pairs_to_workbench
      print_workbench
    end

    private

    def rename_subcommand
      original_key = obrigatory_positional_arg(1, 'key to rename')&.to_sym
      new_name = obrigatory_positional_arg(2, 'new name')&.to_sym
      return unless original_key && new_name
      return puts("Key '#{original_key}' does not exist on workbench".red) unless workbench.key?(original_key)
      return puts("Key '#{new_name}' already exists on workbench".red) if workbench.key?(new_name)

      workbench[new_name] = workbench[original_key]
      workbench.delete(original_key)
    end

    def copy_subcommand
      copy_key = obrigatory_positional_arg(1, 'key to copy')&.to_sym
      resulting_key = obrigatory_positional_arg(2, 'resulting key')&.to_sym
      return unless copy_key && resulting_key
      return puts("Key '#{copy_key}' does not exist on workbench".red) unless workbench.key?(copy_key)

      workbench[resulting_key] = workbench[copy_key]
    end

    def delete_subcommand
      keys = args.positionals[2..]

      puts 'This subcommand should be called with positionals'.yellow if keys.empty?
      keys.map(&:to_sym).each do |key|
        puts "Key #{key} not found on workbench".yellow unless workbench.key?(key)
        workbench.delete(key)
      end
    end

    def pairs_to_workbench
      workbench.merge!(args.pairs)
    end
  end
end
