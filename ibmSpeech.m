% ------------------speech-to-text 

ibm_text = cell(30, 1);
for i = 1:length(dir_list)
    
    flac_file = ['/u/cs401/speechdata/Testing/unkn_' num2str(i) '.flac']; 
    disp(flac_file)
    curl_command = sprintf('env LD_LIBRARY_PATH='''' curl -u "d069b5e3-7496-4f1d-b26c-82d618b56e9a":"Rf2SYjGGw2ao" -X POST --header "Content-Type: audio/flac" --header "Transfer-Encoding: chunked" --data-binary @%s "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize?continuous=true"', flac_file);
    [status, ibm_text{i}] = unix(curl_command);
end

% ------------------text-to-speech
