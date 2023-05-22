import sys
import datetime

def redate_commit(commit, start_timestamp, interval, total_commits):
    commit_number = commit.original_idnum
    new_timestamp = start_timestamp + commit_number * interval
    new_date = datetime.datetime.fromtimestamp(new_timestamp).strftime("%Y-%m-%dT%H:%M:%S") + " +0000"

    commit.author_date = new_date.encode('utf-8')
    commit.committer_date = new_date.encode('utf-8')

start_timestamp = int(sys.argv[1])
interval = int(sys.argv[2])
total_commits = int(sys.argv[3])

commit_callback = lambda commit: redate_commit(commit, start_timestamp, interval, total_commits)
