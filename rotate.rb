require 'mini_magick'
require 'combine_pdf'


# Convert the first page of PDF to an image
def pdf_to_image(pdf_path, jpg_path)
  system("pdftoppm -jpeg -singlefile #{pdf_path} #{jpg_path}")
  "#{jpg_path}.jpg"
end

# detect the orientation of the image
def detect_orientation(image_path)
  result = `tesseract #{image_path} stdout --psm 0 -c min_orientation_margin=1`
  orientation_line = result.lines.find { |line| line.include?("Orientation in degrees:") }
  orientation = orientation_line[/\d+/].to_i
  puts "Detected orientation: #{orientation}°"
  orientation
end

# rotate the image to upright position
def rotate_pdf_to_upright(input_path, output_path, rotate_by)
  pdf = CombinePDF.load(input_path)

  pdf.pages.each do |page|
    page[:Rotate] = ((page[:Rotate] || 0) + rotate_by)
  end

  pdf.save output_path
end

pdf_path = "rotated_output.pdf"
jpg_path = "rotated_output"
output_path = "upright.pdf"

image_path = pdf_to_image(pdf_path, jpg_path)
orientation = detect_orientation(image_path)

rotate_by = 360-orientation

if orientation == 0
  puts "Page is upright"
else
  puts "Page is rotated #{orientation} degrees"
end

rotate_pdf_to_upright(pdf_path, output_path, rotate_by)