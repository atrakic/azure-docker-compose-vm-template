#!/bin/bash

# Start Ollama in the background.
/bin/ollama serve &

# Record Process ID.
pid=$!

# Pause for Ollama to start.
sleep 5

echo "Retrieve codellama model..."
ollama pull codellama 

# Wait for Ollama process to finish.
wait $pid
