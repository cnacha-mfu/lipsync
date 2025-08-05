docker rm lipsync
docker run --gpus all --name lipsync lipsync
docker cp lipsync:/app/result.mp4 ./result.mp4
docker rm lipsync