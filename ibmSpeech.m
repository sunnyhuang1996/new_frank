% ------------------speech-to-text 

%annotate_file = './ibm_transcription.txt';

%fid = fopen(annotate_file, 'w');
%disp(fid)

%for i = 1:30
    
%    flac_file = ['/u/cs401/speechdata/Testing/unkn_' num2str(i) '.flac']; 
%    curl_command = sprintf('env LD_LIBRARY_PATH='''' curl -u "d069b5e3-7496-4f1d-b26c-82d618b56e9a":"Rf2SYjGGw2ao" -X POST --header "Content-Type: audio/flac" --header "Transfer-Encoding: chunked" --data-binary @%s "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize?continuous=true"', flac_file);
%    [status, text] = unix(curl_command);
%    text = strsplit(text, '"');
%    fprintf(fid, '%s\n', text{10});
%end
%    fclose(fid);
% ------------------text-to-speech


% {
%   "credentials": {
%     "url": "https://stream.watsonplatform.net/text-to-speech/api",
%     "password": "3o6vWG9hrUdr",
%     "username": "96c532b7-0e6b-436b-b18f-3f1cfb71028a"
%   }
% }

lik_list = dir('./*.lik');

for i=1:length(lik_list)
	lik_file = ['./' lik_list(i).name];
	[speaker, ll] = textread(lik_file, '%s %f');
	if strcmp(speaker{1}(1), 'M')
		voice = 'en-US_MichaelVoice';
	else
		voice = 'en-US_LisaVoice';
	end
	txt_file = ['/u/cs401/speechdata/Testing/unkn_' num2str(i) '.txt'];
	transcription = textread(txt_file, '%s');
	transcription = transcription(3:end);
	transcription = strjoin(transcription.');
	json_name = ['./unkn_' num2str(i) '.json'];
	json_file = fopen(json_name, 'w');
	
	json_format = sprintf('{"text":"%s"}', transcription);
	fprintf(json_file, json_format);
	output_file = ['ibm_speech' num2str(i) '.flac']
	%disp(json_format)
	%curl_command = sprintf('env LD_LIBRARY_PATH='''' curl -u "96c532b7-0e6b-436b-b18f-3f1cfb71028a":"3o6vWG9hrUdr" -X POST --header "Content-Type: application/json" --header "Accept: audio/flac" --data %s "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=%s"', json_format, voice);
	%disp(curl_command)
	curl_command = sprintf('env LD_LIBRARY_PATH='''' curl -u "96c532b7-0e6b-436b-b18f-3f1cfb71028a":"3o6vWG9hrUdr" -X POST --header "Content-Type: application/json" --header "Accept: audio/flac" --data "@%s" "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=%s" > %s', json_name, voice, output_file);
        status = unix(curl_command);
	disp(status)
	
end
