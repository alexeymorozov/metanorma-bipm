require "isodoc"

module IsoDoc
  module BIPM
    module BaseConvert
      def configuration
        Metanorma::BIPM.configuration
      end

      def middle(isoxml, out)
        middle_title(out)
        middle_admonitions(isoxml, out)
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
      end

      def middle_clause
        "//sections/*"
      end

      def render_identifier(id)
        ret = super
        ret[1] = nil if !id[1].nil? && id[1]["type"] == "BIPM"
        ret[2] = nil if !id[2].nil? && id[2]["type"] == "BIPM"
        ret
      end

      def nonstd_bibitem(list, b, ordinal, biblio)
        list.p **attr_code(iso_bibitem_entry_attrs(b, biblio)) do |ref|
          ids = bibitem_ref_code(b)
          identifiers = render_identifier(ids)
          if biblio then ref_entry_code(ref, ordinal, identifiers, ids)
          else
            ref << "#{identifiers[0] || identifiers[1]}"
            ref << " #{identifiers[1]}" if identifiers[0] && identifiers[1]
          end
          ref << " " unless biblio && !identifiers[1]
          reference_format(b, ref)
        end
      end

      def std_bibitem_entry(list, b, ordinal, biblio)
        list.p **attr_code(iso_bibitem_entry_attrs(b, biblio)) do |ref|
          identifiers = render_identifier(bibitem_ref_code(b))
          if biblio then ref_entry_code(ref, ordinal, identifiers, nil)
          else
            ref << "#{identifiers[0] || identifiers[1]}"
            ref << " #{identifiers[1]}" if identifiers[0] && identifiers[1]
          end
          date_note_process(b, ref)
          ref << " " unless biblio && !identifiers[1]
          reference_format(b, ref)
        end
      end
    end
  end
end
