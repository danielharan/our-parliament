require 'test_helper'

class SenatorTest < ActiveSupport::TestCase
  def test_normalize_name
    s = Factory(:senator, :name => "Banks, Tommy")
    
    assert_equal "Banks, Tommy", s.name
    assert_equal "Tommy Banks", s.normalized_name
  end
  
  
  def test_senator_extraction
    s = Senator.scrape_senator Nokogiri::HTML("<tr><td>\r\n\t\t\t\r\n\t\r\n\t\t\r\n\t\t\t\r\n\t\t\t\t \t\t\t\t<a HREF=\"isenator_det.asp?senator_id=2&sortord=N&Language=E&M=M\">Andreychuk,&nbsp;Raynell</a>\r\n\t\t\t\t\t\t\r\n\t\t\t</td>\r\n\t\t\t\r\n\t\t\t\r\n\t\t\t<td align=\"center\">\r\n\t\t\tC\t\t\t\t\r\n\t\t\t\r\n\t\t\t</td>\r\n\t\t\t\r\n\t\t\t\r\n\t\t\t<td>Saskatchewan    &nbsp;(Saskatchewan)\r\n\t\t\t</td>\r\n\t\t\t<td>\r\n\t\t\t1993-03-11\r\n\t\t\t</td>\r\n\t\t\t<td>\r\n\t\t\t2019-08-14\r\n\t\t\t</td>\r\n\t\t\t<td>Mulroney (Prog. Conser.)\t\t\t\r\n\t\t\t</td>\r\n\t\t\t</tr>")
    
    assert_equal "Andreychuk, Raynell", s.name
    assert_equal "C", s.affiliation
    assert_equal "Saskatchewan (Saskatchewan)", s.province
    assert_equal "1993-03-11", s.nomination_date.to_s
    assert_equal "2019-08-14", s.retirement_date.to_s
    assert_equal "Mulroney (Prog. Conser.)", s.appointed_by
  end
  
  def test_missing_affiliation_handling
    s = Senator.scrape_senator Nokogiri::HTML("<tr><td>\r\n\t\t\t\r\n\t\r\n\t\t\r\n\t\t\t\r\n\t\t\t\t \t\t\t\t<a HREF=\"isenator_det.asp?senator_id=21&sortord=N&Language=E&M=M\">Cools,&nbsp;Anne C.</a>\r\n\t\t\t\t\t\t\r\n\t\t\t</td>\r\n\t\t\t\r\n\t\t\t\r\n\t\t\t<td align=\"center\">\r\n\t\t\t\r\n\t\t\t\r\n\t\t\t\t  &nbsp;\r\n\t\t\t\t  \r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\r\n\t\t\t</td>\r\n\t\t\t\r\n\t\t\t\r\n\t\t\t<td>Ontario         &nbsp;(Toronto Centre-York)\r\n\t\t\t</td>\r\n\t\t\t<td>\r\n\t\t\t1984-01-13\r\n\t\t\t</td>\r\n\t\t\t<td>\r\n\t\t\t2018-08-12\r\n\t\t\t</td>\r\n\t\t\t<td>Trudeau (Lib.)\t\t\t\r\n\t\t\t</td>\r\n\t\t\t</tr>")
    
    assert_equal "Cools, Anne C.", s.name
    assert_equal "", s.affiliation
  end
end
