from __future__ import print_function
import aerospike
import pprint
config = {
  'hosts': [("192.168.100.88", 3000,)]
}
try:
  client = aerospike.client(config).connect()
except Exception as t:
  print("Connection Error: {0} [{1}]".format(t.msg, t.code))

#write record
try:
  client = aerospike.client(config).connect()
  key = ('orders', 'products', 1)
  bins = {
      'product': 'Laptop',
      'cost': 80000,
  }
  client.put(key, bins, meta={'ttl':60})
    
except Exception as e:
  print("DB Write Error: {0} [{1}]".format(e.msg, e.code))

#read record
try:
  pp = pprint.PrettyPrinter(indent=2)
  (key, meta, bins) = client.get(key)
  pp.pprint(key)
  pp.pprint(meta)
  pp.pprint(bins)
except Exception as ex:
  print("DB Read Error: {0} [{1}]".format(ex.msg, ex.code))