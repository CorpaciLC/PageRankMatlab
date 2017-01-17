function [indices foundString] = searchBy(myString, maxFiles)
    directory = fullfile(pwd, 'Pages/*.html');
    filesAndFolders = dir(directory); % Returns all the files and folders in the directory
    filesInDir = filesAndFolders(~([filesAndFolders.isdir]));  % Returns only the files in the directory                    
    stringToBeFound = myString;
    numOfFiles = min(length(filesInDir), maxFiles);
    i = 1;
    k = 1;
    indices = 0;
    foundString = {'0'};
    while(i<=numOfFiles)
      fclose('all'); % Close all open files
      filename = filesInDir(i).name;    
      fid = fopen(strcat('.\Pages\', filename), 'a');
      contentOfFile = fileread(strcat('.\Pages\', filename));% Read the file line-by-line and store the content
      found = strfind(contentOfFile,stringToBeFound); % Search for the stringToBeFound in contentOfFile
      if ~isempty(found)
         foundString{k} = filename;
         index = '';
         for j = 5:length(filename)
            if ~isempty(str2num(filename(j)))
                index = strcat(index, filename(j));
            else break;
            end
         end
         indices(k) = str2num(index);
         k = k + 1;
      end
      fclose(fid);                                               
      i = i+1;
    end
end