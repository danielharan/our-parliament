Factory.sequence :id do |n|
  n
end

Factory.define :mp do |mp|
  mp.ed_id { Factory.next :id }
  mp.parl_gc_id { Factory.next :id }
  mp.parl_gc_constituency_id { Factory.next :id }
  
  mp.constituency_name "Winnipeg"
  mp.constituency_province "Manitoba"
  mp.party "Independent"
  mp.name { Factory.next :id }
end

Factory.define :senator do |s|
  s.name { Factory.next :id}
  s.affiliation ["C", "Lib"].rand
  s.province ["ON", "QC", "NS"].rand
  s.nomination_date Date.parse("1993-03-11")
  s.retirement_date Date.parse("2019-08-14")
  s.appointed_by "Mulroney (Prog. Conser.)"
end

Factory.define :vote do |v|
  v.bill_number "C2"
end