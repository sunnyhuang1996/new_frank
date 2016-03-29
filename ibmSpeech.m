% ------------------speech-to-text 

annotate_file = './ibm_transcription.txt';

fid = fopen(annotate_file, 'w');
disp(fid)

for i = 1:30
    
    flac_file = ['/u/cs401/speechdata/Testing/unkn_' num2str(i) '.flac']; 
    curl_command = sprintf('env LD_LIBRARY_PATH='''' curl -u "d069b5e3-7496-4f1d-b26c-82d618b56e9a":"Rf2SYjGGw2ao" -X POST --header "Content-Type: audio/flac" --header "Transfer-Encoding: chunked" --data-binary @%s "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize?continuous=true"', flac_file);
    [status, text] = unix(curl_command);
    text = strsplit(text, '"');
    fprintf(fid, '%s\n', text{10});
end
    fclose(fid);
% ------------------text-to-speech


% {
%   "credentials": {
%     "url": "https://stream.watsonplatform.net/text-to-speech/api",
%     "password": "3o6vWG9hrUdr",
%     "username": "96c532b7-0e6b-436b-b18f-3f1cfb71028a"
%   }
% }