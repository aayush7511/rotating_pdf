# frozen_string_literal: true

require 'combine_pdf'

# Load your PDF
pdf = CombinePDF.load("resume-final.pdf")

# Rotate **all** pages by 90° clockwise:
pdf.pages.each do |page|
  # either:
  page[:Rotate] = (page[:Rotate] || 0) - 90
  # or, with CombinePDF ≥ 1.0:
  # page.rotate(90)
end

# Write out the rotated PDF
pdf.save "rotated_output.pdf"
