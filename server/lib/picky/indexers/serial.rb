# encoding: utf-8
#
module Picky

  module Indexers

    # Uses a category to index its data.
    #
    # Note: It is called serial since it indexes each category separately.
    #
    class Serial < Base

      # Harvest the data from the source, tokenize,
      # and write to an intermediate "prepared index" file.
      #
      # Parameters:
      #  * categories: An enumerable of Category-s.
      #
      def process categories
        categories.each do |category|

          category.prepared_index_file do |file|

            datas = []
            result = []
            tokenizer = category.tokenizer

            source.harvest(category) do |*data|

              # Accumulate data.
              #
              datas << data
              next if datas.size < 10_000

              # Opening the file inside the scheduler to
              # have it automagically closed.
              #
              index_flush datas, file, result, tokenizer

              datas.clear

            end

            index_flush datas, file, result, tokenizer

            yield file
          end
        end

      end

      def index_flush datas, file, cache, tokenizer
        comma   = ?,
        newline = ?\n

        datas.each do |indexed_id, text|
          tokens, _ = tokenizer.tokenize text # Note: Originals not needed.
          tokens.each do |token_text|
            next unless token_text
            cache << indexed_id << comma << token_text << newline
          end
        end

        flush file, cache
      end

      def flush prepared_file, cache
        prepared_file.write(cache.join) && cache.clear
      end

    end
  end

end