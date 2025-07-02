# log_sweeper.py

from sweeper.core import parse_logs, archive_logs
import argparse

def main():
    args = get_args()
    logs = parse_logs(args.input, args.patterns)
    archive_logs(logs, args.output)

if __name__ == "__main__":
    main()
