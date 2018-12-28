#!/usr/bin/env python3

import os
import sys

print("This will change ownership on all files in the current directory!")
print("This can fix the uid/gid of files wrongly copied from containers.")
confirm = input("Continue? [y/N] ")
if confirm not in ("y","Y","yes","Yes"):
    sys.exit(1)

def unmap_ids(path):
    if os.path.islink(path):
        return
    statres = os.stat(path)
    newgid = statres.st_gid%100000
    newuid = statres.st_uid%100000
    if statres.st_gid != newgid or statres.st_uid != newuid:
        print("%s:%s -> %s:%s : %s" % (statres.st_uid, statres.st_gid, newuid, newgid, path))
        os.chown(path, newuid, newgid)

for item in os.walk("."):
    dir, subdirs, files = item
    unmap_ids(dir)
    for partial in files:
        unmap_ids(os.path.join(dir,partial))

