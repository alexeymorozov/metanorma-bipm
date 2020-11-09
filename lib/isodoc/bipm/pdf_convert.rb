require "isodoc"

module IsoDoc
  module BIPM
    # A {Converter} implementation that generates PDF HTML output, and a
    # document schema encapsulation of the document for validation
    class PdfConvert <  IsoDoc::XslfoPdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def pdf_stylesheet(docxml)
        doctype = docxml&.at(ns("//bibdata/ext/doctype"))&.text
        doctype = "brochure" unless %w(guide mise-en-pratique rapport).
          include? doctype
        "bipm.#{doctype}.xsl"
      end

      def pdf_options(docxml)
        if docxml.root.name == "metanorma-collection"
          "--split-by-language"
        else
          super
        end
      end
    end
  end
end

