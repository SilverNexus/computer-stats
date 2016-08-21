computer-stats - a computer metric aggregation script

As of this time, the script takes no arguments. Just run it and it should work.

To install it as a cron job, perform the following:
1. Copy computer-stats.pl to /etc/cron.d/
2. run `crontab -e`
3. Add the following line to the crontab:
    */10 * * * * perl /etc/cron.d/computer-stats.pl
    
    This will make the script run every ten minutes.
4. Exit the text editor that crontab -e opened and save your changes if not done already.
    This automatically updates cron to read the new crontab, so no further action is required.

This will result in the generated csv being written to your home folder. It should be called usage_log.csv.
