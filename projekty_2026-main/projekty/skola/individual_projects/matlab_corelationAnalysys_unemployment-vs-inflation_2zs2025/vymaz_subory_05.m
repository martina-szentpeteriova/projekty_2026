
% vymaz_subory_05.m
% maze vsetko co nieje m-file v priecinku
allowedExtensions = {'.m', '.xlsx', '.pdf', '.docx'}; % zoznam povolenych pripon
folderPath = pwd;  % aktualny priecinok, kde su .m súbory
files = dir(folderPath);

for k = 1:length(files)
    if files(k).isdir
        continue;
    end
    
    % fileparts rozdeli cestu k suboru na 3 casti
    % cesta, nazov suboru, pripona
    [~,~,ext] = fileparts(files(k).name);
    
    % ak pripona nie je v zozname povolených -> odstranit
    if ~any(strcmpi(ext, allowedExtensions))
        fullFileName = fullfile(folderPath, files(k).name);
        fprintf('Odstraňujem %s ...\n', fullFileName);
        delete(fullFileName);
    end
end

% odstrani vsetky premenne okrem 'vystup_tbl'
fprintf('Odstraňujem premenné vo Workspace ...\n');
clearvars -except vystup_tbl

