Factory.sequence :id do |n|
  n
end

Factory.define :mp do |mp|
  mp.ed_id { Factory.next :id }
  mp.parl_gc_id { Factory.next :id }
  mp.parl_gc_constituency_id { Factory.next :id }
  
  mp.constituency_name "Winnipeg"
  mp.party "Independent"
end
