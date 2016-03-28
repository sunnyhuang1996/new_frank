% ------------------speech-to-text 
%flac_file = 
curl_command = sprintf('env LD_LIBRARY_PATH='''' curl -u "d069b5e3-7496-4f1d-b26c-82d618b56e9a":"Rf2SYjGGw2ao" -X POST --header "Content-Type: audio/flac" --header "Transfer-Encoding: chunked" --data-binary @%s " "https://gateway.watsonplatform.net/speech-to-text/api/v2/recognize?continuous=true"', flac_file);


% ------------------text-to-speech
