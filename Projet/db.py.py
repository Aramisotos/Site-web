import psycopg2
import psycopg2.extras

import psycopg2
import psycopg2.extras

def connect():
  conn = psycopg2.connect(
    dbname = 'yanis.twardawa_db',
    host = 'sqletud.u-pem.fr',
    password = 'ced29b',
    cursor_factory = psycopg2.extras.NamedTupleCursor
  )
  conn.autocommit = True
  return conn