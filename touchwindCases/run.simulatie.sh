#!/bin/bash

# Email credentials
FROM_EMAIL="sowfa.touchwind@gmail.com"
TO_EMAIL="abe.willems@touchwind.org"
SMTP_SERVER="smtp.gmail.com:587"
USERNAME="sowfa.touchwind@gmail.com"
PASSWORD="zofqirzlwqpeharp"

# Flag to track if the initial email has been sent
initial_email_sent=false

while true; do
    # Check if there are any jobs in the queue
    if [ -s job.queue ]; then
        # Send initial start email only once when a job is found
        if [ "$initial_email_sent" = false ]; then
            echo " "
			sendemail -f "$FROM_EMAIL" -t "$TO_EMAIL" -u "STARTING Simulations On Server" -m "Starting queued simulations on the server." -s "$SMTP_SERVER" -o tls=yes -xu "$USERNAME" -xp "$PASSWORD"
            initial_email_sent=true
        fi

        # Get the first job from the queue
        NAME=$(head -n 1 job.queue)

        # Run the job
		echo " "
        echo "##### Running $NAME #####"
        cd ./$NAME
        chmod u+rwx ./runscript.complete
        ./runscript.complete
        cd ..

        # Remove the job from the queue
        sed -i '1d' job.queue

        # Get remaining job count
        remaining_jobs=$(wc -l < job.queue)

        # Send progress email with remaining job count
        sendemail -f "$FROM_EMAIL" -t "$TO_EMAIL" -u "PROGRESS Simulation On Server" -m "The simulation named \"$NAME\" has completed. There are $remaining_jobs simulations left in the queue." -s "$SMTP_SERVER" -o tls=yes -xu "$USERNAME" -xp "$PASSWORD"

        # Small delay before checking for the next job
        sleep 10

        # Check if all jobs are complete after each job is finished
        if [ ! -s job.queue ]; then
            sendemail -f "$FROM_EMAIL" -t "$TO_EMAIL" -u "FINISHED Simulations On Server" -m "All simulations on the server have been completed. You can safely turn the server off now." -s "$SMTP_SERVER" -o tls=yes -xu "$USERNAME" -xp "$PASSWORD"
            initial_email_sent=false  # Reset flag so "STARTING" email can be sent next time jobs are added
        fi
    else
        # Reset the initial email flag when the queue is empty and no jobs are running
        initial_email_sent=false
		echo " "
		echo "No jobs found. Waiting for new jobs..."
		echo " "
        sleep 30
    fi
done
