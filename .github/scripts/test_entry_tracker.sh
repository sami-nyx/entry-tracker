#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Waiting for the application to be ready..."
sleep 30

echo "=== Run 1: Checking for Success Message ==="
# Run curl and save response to a variable
RESPONSE_1=$(curl -s -f http://localhost:5000/)

# Verify the success message exists in the output
if echo "$RESPONSE_1" | grep -q "Data fetched successfully from the database."; then
  echo "✓ Success message found!"
else
  echo "✗ Expected success message not found!"
  exit 1
fi

# Hit the endpoint two more times to populate entries
curl -fs http://localhost:5000/ > /dev/null
curl -fs http://localhost:5000/ > /dev/null

echo "=== Run 2: Verifying Entry Count ==="
# Fetch the lengths of previous entries
ENTRY_COUNT=$(curl -fs http://localhost:5000/ | jq '.previous_entries | length')

if [ "$ENTRY_COUNT" -eq 4 ]; then
  echo "✓ Success! The database accurately tracked 4 entries."
else
  echo "✗ Error! Expected 4 entries, but found $ENTRY_COUNT."
  exit 1
fi