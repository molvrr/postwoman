module Commands
  class List < Base
    ALIASES = %w[ls all loaders].freeze
    DESCRIPTION = 'Lists all loaders'.freeze

    def execute
      loaders = fetch_loader_names.map do |loader_name|
        snakecased = snakecase(loader_name)
        next snakecased.yellow if snakecased == 'base'

        snakecased
      end.join(' ')
      puts loaders
    end
  end
end
