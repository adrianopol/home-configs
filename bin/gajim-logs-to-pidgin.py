# Convets Gajim's Jabber history to a Pidgin's plaint-text history format.
#
# Usage:
#
#   cp ~/.local/share/gajim/logs.db .
#   python3 gajim-logs-to-pidgin.py

import datetime
import os
import sqlite3

# 'kind' field (see https://dev.gajim.org/gajim/gajim/-/wikis/development/logsdatabase)
logs_kind_recv = 4 # chat_msg_recv
logs_kind_sent = 6 # chat_msg_sent

def do_need_prefix(path):
    return not os.path.exists(path) or os.path.getsize(path) == 0

c = sqlite3.connect('logs.db')
cur = c.cursor()

# XXX: assuming my JID to be stored in the jids table with jid_id = 1:
my_jid = cur.execute('select jid from jids where jid_id = 1').fetchone()[0]
my_nick = my_jid[:my_jid.index('@')]

rows = cur.execute(
    "select kind, time, message, jid from logs join jids on logs.jid_id = jids.jid_id"
)

for row in rows:
    jid = row[3]

    from_acc = my_nick if row[0] == logs_kind_sent else jid[:jid.index('@')]
    # need tzinfo object in order to '%z' and '%Z' produce non-empty TZ strings
    ts = datetime.datetime.fromtimestamp(row[1], tz=datetime.datetime.now().astimezone().tzinfo)
    ts_date = ts.strftime('%c')
    ts_time = ts.strftime('%X')
    msg = row[2]

    path = os.path.join(my_jid, jid)
    file = os.path.join(path, ts.strftime("%Y-%m-%d.000000%z%Z.txt"))

    os.makedirs(path, exist_ok=True)
    need_prefix = do_need_prefix(os.path.join(file))
    with open(file, 'a') as f:
        if need_prefix:
            f.write(f'Conversation with {jid} at {ts_date} on {my_jid} (jabber)\n')
        f.write(f'({ts_time}) {from_acc}: {msg}\n')

c.close()
