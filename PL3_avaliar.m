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
T=[ 0 , 1/4 , 1/3 , 1/3 , 0 ; 1/2 , 0 , 1/3 , 0 , 0 ; 0 , 1/4 , 0 , 1/3 , 0 ; 1/2 , 1/4 , 1/3 , 0 , 0 ; 0 , 1/4 , 0 , 1/3 , 0];               
%
%
%      1   2   3   4   5
%    -                 -      
% 1 |  0  1/4 1/3 1/3  0 |      1 = r
% 2 | 1/2  0  1/3  0   0 |      2 = o
% 3 |  0  1/4  0  1/3  0 |      3 = m
% 4 | 1/2 1/4 1/3  0   0 |      4 = a
% 5 |  0  1/4  0  1/3  0 |      5 = .
%    -                 -
    
% how to use crawl()
state = crawl(T, 1, 5);
result = stringify(state)
%  
%     (b) Simulate the generation of 10^5 random words to estimate the list of generated words and the probability of each word. How many different words were generated? 

N = 10^5;                    % numero de palavras geradas
resultados = {};
contadores = [];
counter = 0;              % numero de palavras unicas geradas
for i = 1:N
    result = stringify(crawl(T, 1, 5));
    if any(strcmp(resultados,result))
        index = find(strcmp(result, resultados));
        contadores(index) = contadores(index) + 1;
    else
        counter = counter + 1;
        resultados{counter} = result;
        contadores(counter) = 1;
    end
end
% 
% Present the 5 words with the highest estimated probabilities and their probability values.

Big = maxk(contadores,5); % top 5 numero de vezes que as palavras se repetem
for n = 1:length(Big)
    temp = resultados((contadores==Big(n)));
    for m = 1:length(temp)
        fprintf("Probabilidade de %s é igual a %.2f\n",temp{m},Big(n)/N);
    end
end
%  
%     (c) Determine the theoretical probabilities of the 5 words presented in the previous question. Compare the theoretical values with the previous estimated values. What do you conclude?


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
Prob = counter/N
%  
%     (e) Change your random word generator to consider a new input parameter n representing the maximum word size (in number of letters) of the generated words (i.e., the word generator stops either if it reaches the state ‘.’ or if it reaches n letters).

% how to use crawl2()
state = crawl2(T, 1, 5, 2);
result = stringify(state)
%  
%     (f) For n = 8, 6 and 4, simulate the generation of 10^5 random words to estimate the number of generated words and the probability of a generated word being a valid Portuguese word. Compare these results between them and with the results of 1b) and 1d). What do you conclude? Explain your conclusions!

for s = [8 6 4]
    resultados = {};
    contadores = [];
    counter = 0;              % numero de palavras unicas geradas
    for i = 1:N
        result = stringify(crawl2(T, 1, 5,s));
        if any(strcmp(resultados,result))
            index = find(strcmp(result, resultados));
            contadores(index) = contadores(index) + 1;
        else
            counter = counter + 1;
            resultados{counter} = result;
            contadores(counter) = 1;
        end
    end
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
    Prob = counter/N 
end