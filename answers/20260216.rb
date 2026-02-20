module Answer
  # - Question::Issue20260216
  # - Benchmark::Issue20260216
  #
  module Issue20260216
    # :section: Original answer
    module ZoomifyArray
      refine Array do
        def zoom_in_by(factor)
          raise ArgumentError, "Factor MUST be an Integer greater than or equal to 2!" unless factor.is_a?(Integer) && factor >= 2

          number_of_rows = size
          number_of_cols = first.size
          bigger_grid    = Array.new(number_of_rows * factor) { Array.new(number_of_cols * factor) }

          each_with_index do |row, row_index|
            row.each_with_index do |cell, col_index|
              0.upto(factor - 1) do |shift_row_index|
                0.upto(factor - 1) do |shift_col_index|
                  bigger_grid[(row_index * factor) + shift_row_index][(col_index * factor) + shift_col_index] = cell
                end
              end
            end
          end

          bigger_grid
        end
      end
    end

    using ZoomifyArray

    # A [monkey-patched](rdoc-ref:Answer::Issue20260216::ZoomifyArray), n00by,
    # implement-the-first-obvious-pattern, 'Shameless Green', 4-nested-loops (YUCK!)
    # version inspired by the recent exposure to Sandi Metz’s 'Smalltalkism' ---
    # I really like the idea of sending messages to the objects! 🙃
    #
    def izkreny_zoom(grid, factor)
      grid.zoom_in_by(factor)
    end

    # :section: Ruby Users Forum answers
    #
    # Topic [Cassidoo’s Interview question of the week | 444][ruf]
    #
    # [ruf]: https://www.rubyforum.org/t/cassidoo-s-interview-question-of-the-week-444/124

    # Flat & map by charlie
    #
    def charlie_zoom(matrix, factor)
      raise ArgumentError, "factor must be >= 2" unless factor >= 2

      matrix.map do |vector|
        repeated_items = vector.flat_map { [it] * factor }

        Array.new(factor, repeated_items)
      end.flatten(1)
    end

    module EachWithYielder
      refine Enumerable do
        def each_with_yielder
          Enumerator.new do |yielder|
            each { |item| yield yielder, item }
          end
        end
      end
    end

    using EachWithYielder

    # Enumerable [monkey-patched](rdoc-ref:Answer::Issue20260216::EachWithYielder)
    # version by lpogic modified (with AI) to be more readable
    #
    def lpogic_zoom(grid, factor)
      grid.each_with_yielder do |grid_yielder, row|
        factor.times do
          grid_yielder << row.each_with_yielder do |row_yielder, cell|
            factor.times do
              row_yielder << cell
            end
          end.to_a
        end
      end.to_a
    end

    # One-liner by fpsvogel
    #
    def fpsvogel_zoom(grid, factor) = grid.map { |row| row.flat_map { |col| [col] * factor } }.flat_map { |row| [row] * factor }

    # Flat & map (AI) version by eayurt
    #
    def eayurt_zoom(grid, factor)
      result = []

      grid.each do |row|
        zoomed_row = row.flat_map { |cell| [cell] * factor }
        factor.times { result << zoomed_row }
      end

      result
    end

    # Flat & map (AI?) version by roasted-oolong (syntax corrected)
    #
    def roasted_oolong_zoom(grid, factor)
      return "error" if factor < 2

      grid.flat_map do |row|
        more_rows = row.flat_map { |n| [n] * factor } # Multiply rows by integer
        [more_rows] * factor # Repeat rows by integer
      end
    end
  end
end
