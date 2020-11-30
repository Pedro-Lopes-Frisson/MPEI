%% 3.1 Section for evaluation
% 
% 
% Consider the random generation of Portuguese words based on Markov chains. 
% To evaluate the efficiency of a random word generator, consider 2 parameters: 
% (1) the number of different generated words and (2) the probability of a generated 
% word being a valid Portuguese word. The higher these two parameters are, the 
% more efficient the random word generator is. 
% 
% In the following experiments, consider the random generation of Portuguese 
% words composed only by the letters ‘a’, ‘m’, ‘o’ and ‘r’. Consider also the 
% file wordlist-preao-20201103.txt (publicly available at https://natura.di.uminho.pt/download/sources/Dictionaries/wordlists/) 
% with a list of almost 1 million valid Portuguese words, organized in 1 word 
% per row.
%     1. (Evaluation weight = 60%) Assume that the random word generator is based on a Markov chain represented by the following state transition diagram where the transition probability from each state is the same for all possible next states (the state ‘.’ indicates that the previous letter is the last letter of the word):
% 
% and the probability of the first letter is the same for all letters.
% 
%     (a) Define, in Matlab, the state transition matrix T and simulate the generation of a random word (in Annex, you have a proposal of a function crawl that you can use to implement the simulation).

% State transition of the problem
T=[ 0 , 1/3 , 0 , 1/4 , 0 ; 1/2 , 0 , 1/2 , 1/4 , 0 ; 0 , 1/3 , 0 , 1/4 , 0 ; 1/2 , 0 , 1/2 , 0 , 0 ; 0 , 1/3 , 0 , 1/4 , 0];               
%
%
%      1   2   3   4   5
%    -                 -      
% 1 |  0  1/3  0  1/4  0 |      1 = r
% 2 | 1/2  0  1/2 1/4  0 |      2 = o
% 3 |  0  1/3  0  1/4  0 |      3 = m
% 4 | 1/2  0  1/2  0   0 |      4 = a
% 5 |  0  1/3  0  1/4  0 |      5 = .
%    -                 -   
% how to use crawl()
state = crawl(T, randi([1,4],1,1), 5);
result = stringify(state)
%  
%     (b) Simulate the generation of 10^5 random words to estimate the list of generated words and the probability of each word. How many different words were generated? 

N = 10^5;                    % numero de palavras geradas
resultados = {};
contadores = [];
counter = 0;              % numero de palavras unicas geradas
for i = 1:N
    result = stringify(crawl(T, randi([1,4],1,1), 5));
    if any(strcmp(resultados,result))
        index = find(strcmp(result, resultados));
        contadores(index) = contadores(index) + 1;
    else
        counter = counter + 1;
        resultados{counter} = result;
        contadores(counter) = 1;
    end
end
fprintf("Numero de palavras distintas geradas: %d\n",counter);
% 
% Present the 5 words with the highest estimated probabilities and their probability values.

Big = maxk(contadores,5); % top 5 numero de vezes que as palavras se repetem
tops = {};
count=1;
for n = 1:length(Big)
    temp = resultados((contadores==Big(n)));
    for m = 1:length(temp)
        fprintf("Probabilidade de %s é igual a %.2f\n",temp{m},Big(n)/N);
        tops{count} = temp{m};
        count = count + 1;
    end
end
%  
%     (c) Determine the theoretical probabilities of the 5 words presented in the previous question. Compare the theoretical values with the previous estimated values. What do you conclude?

%              T 
%
%      1   2   3   4   5
%    -                 -      
% 1 |  0  1/3  0  1/4  0 |      1 = r
% 2 | 1/2  0  1/2 1/4  0 |      2 = o
% 3 |  0  1/3  0  1/4  0 |      3 = m
% 4 | 1/2  0  1/2  0   0 |      4 = a
% 5 |  0  1/3  0  1/4  0 |      5 = .
%    -                 -   
%
% Equações de Chapman-Kolmogorov
%
% pij^(n+m) = Ek pki^n pik^m  todo n,m >=0, todo i,j
%
for i = 1:length(tops)
    prob = 1/4;
    for s = 1:length(tops{i})
        if(s==1)
            switch (tops{i}(s))
                case 'r'
                    prev = 1;
                case 'o'
                    prev = 2;
                case 'm'
                    prev = 3;
                case 'a'
                    prev = 4;
            end
        else
            switch (tops{i}(s))
                case 'r'
                    prob = prob*T(1,prev);
                    prev = 1;
                case 'o'
                    prob = prob*T(2,prev);
                    prev = 2;
                case 'm'
                    prob = prob*T(3,prev);
                    prev = 3;
                case 'a'
                    prob = prob*T(4,prev);
                    prev = 4;
            end            
        end
        if(s==length(tops{i}))
            prob = prob*T(5,prev);
        end
    end
    prob
end
%  
%     (d) Import (from file wordlist-preao-20201103.txt) the list of Portuguese words to a cell array. With this list and the results of the previous question, estimate the probability of the random word generator to generate a valid Portuguese word.

str = extractFileText('wordlist-preao-20201103.txt');
wrds= convertStringsToChars(split(str));
counter = 0;
for i = 1:length(resultados)
    if(any(strcmp(wrds,resultados{i})))
        counter = counter + contadores(i);
    end
end
fprintf("Probabilidade de serem palavras Poruguesas validas: %f\n\n",counter/N);
%  
%     (e) Change your random word generator to consider a new input parameter n representing the maximum word size (in number of letters) of the generated words (i.e., the word generator stops either if it reaches the state ‘.’ or if it reaches n letters).

% how to use crawl2()
state = crawl2(T, randi([1,4],1,1), 5, 2);
result = stringify(state)
%  
%     (f) For n = 8, 6 and 4, simulate the generation of 10^5 random words to estimate the number of generated words and the probability of a generated word being a valid Portuguese word. Compare these results between them and with the results of 1b) and 1d). What do you conclude? Explain your conclusions!

for s = [8 6 4]
    fprintf("Probabilidade para n = %d\n",s);
    resultados = {};
    contadores = [];
    counter = 0;              % numero de palavras unicas geradas
    for i = 1:N
        result = stringify(crawl2(T, randi([1,4],1,1), 5,s));
        if any(strcmp(resultados,result))
            index = find(strcmp(result, resultados));
            contadores(index) = contadores(index) + 1;
        else
            counter = counter + 1;
            resultados{counter} = result;
            contadores(counter) = 1;
        end
    end
    fprintf("Numero de palavras distintas geradas: %d\n",counter);
    Big = maxk(contadores,5); % top 5 numero de vezes que as palavras se repetem
    for n = 1:length(Big)
        temp = resultados((contadores==Big(n)));
        for m = 1:length(temp)
            fprintf("Probabilidade de %s é igual a %.2f\n",temp{m},Big(n)/N);
        end
    end
    str = extractFileText('wordlist-preao-20201103.txt');
    wrds= convertStringsToChars(split(str));
    counter = 0;
    for i = 1:length(resultados)
        if(any(strcmp(wrds,resultados{i})))
            counter = counter + contadores(i);
        end
    end
    fprintf("Probabilidade de serem palavras Poruguesas validas: %f\n\n",counter/N);
end
% 
% 2. (Evaluation weight = 10%) Change the state transition matrix T assuming now the transition probabilities defined in the following diagram: 
% Assume again that the probability of the first letter is the same for all letters. For n = ∞, 8, 6 and 4, simulate the generation of 10^5 random words to estimate the number of different generated words and the probability of a generated word being a valid Portuguese word. Analyse the obtained results and compare them with the previous results. What do you conclude on the efficiency of these word generators when compared with the previous ones? Explain your conclusions!

% State transition of the problem
T=[ 0 , 0.3 , 0 , 0.3 , 0 ; 0.3 , 0 , 0.3 , 0.1 , 0 ; 0 , 0.2 , 0 , 0.2 , 0 ; 0.7 , 0 , 0.7 , 0 , 0 ; 0 , 0.5 , 0 , 0.4 , 0];               
%
%
%      1   2   3   4   5
%    -                 -      
% 1 |  0  0.3  0  0.3  0 |      1 = r
% 2 | 0.3  0  0.3 0.1  0 |      2 = o
% 3 |  0  0.2  0  0.2  0 |      3 = m
% 4 | 0.7  0  0.7  0   0 |      4 = a
% 5 |  0  0.5  0  0.4  0 |      5 = .
%    -                 -   

for s = [8 6 4 0]
    fprintf("Probabilidade para n = %d\n",s);
    resultados = {};
    contadores = [];
    counter = 0;              % numero de palavras unicas geradas
    if(s~=0)
        for i = 1:N
            result = stringify(crawl2(T, randi([1,4],1,1), 5,s));
            if any(strcmp(resultados,result))
                index = find(strcmp(result, resultados));
                contadores(index) = contadores(index) + 1;
            else
                counter = counter + 1;
                resultados{counter} = result;
                contadores(counter) = 1;
            end
        end
    else
        for i = 1:N
            result = stringify(crawl(T, randi([1,4],1,1), 5));
            if any(strcmp(resultados,result))
                index = find(strcmp(result, resultados));
                contadores(index) = contadores(index) + 1;
            else
                counter = counter + 1;
                resultados{counter} = result;
                contadores(counter) = 1;
            end
        end        
    end
    fprintf("Numero de palavras distintas geradas: %d\n",counter);
    Big = maxk(contadores,5); % top 5 numero de vezes que as palavras se repetem
    for n = 1:length(Big)
        temp = resultados((contadores==Big(n)));
        for m = 1:length(temp)
            fprintf("Probabilidade de %s é igual a %.2f\n",temp{m},Big(n)/N);
        end
    end
    str = extractFileText('wordlist-preao-20201103.txt');
    wrds= convertStringsToChars(split(str));
    counter = 0;
    for i = 1:length(resultados)
        if(any(strcmp(wrds,resultados{i})))
            counter = counter + contadores(i);
        end
    end
    fprintf("Probabilidade de serem palavras Poruguesas validas: %f\n\n",counter/N); 
end
%% 
% 
% 3. (Evaluation weight = 10%) Consider the state transition matrix T of the question 2. Using the words in wordlist-preao-20201103.txt involving only the letters ‘a’, ‘m’, ‘o’ and ‘r’, estimate the probability of the first letter of a word based on the number of words starting on each of these letters. Repeat question 2 assuming these new probabilities for the first letter. Analyse the obtained results and compare them with the previous results. What do you conclude on the efficiency of these word generators when compared with the previous ones? Explain your conclusions!