using StatsBase

#Choosing a language and loading vocabulary
println("Choose your language (\"fr\",\"ger\",\"eng\"): ")
lang = readline(stdin)
if in(lang, ["fr","french"])
    global LIST = readlines("francais.txt")
elseif in(lang, ["ger","german"])
    global LIST = readlines("deutsch.txt")
else
    global LIST = readlines("english.txt")
end

#filtering of 5 letters words
filter!(a -> length(a) == 5, LIST)

#creating a dict translating non latin letters to latin
tolatin = Dict()
for line in readlines("tolatin.txt")
    v, k = split(line)
    for key in k
        tolatin[key] = v
    end
end

#function - converts letters to lowercase and to latin
function convert(word::String)
    new_word = ""
    for letter in lowercase(word)
        new_word *= tolatin[letter]
    end
    return new_word
end

#function - filters words with non letter signs
function onlyletters(List)
    lst = []
    for ele in List
        breaker = false
        for letter in ele
            if !isletter(letter)
                breaker = true;
            end
        end
        if !breaker
            push!(lst, ele)
        end
    end
    return lst
end


LIST = onlyletters(LIST)
LIST = [convert(x) for x in LIST]
unique!(LIST)
list = copy(LIST)

#count letters dict
countdict = countmap(collect(join(LIST)))
println(countdict)

#starting values
cont = []
isnot = []
isnoton = []
solved = ['0' '0' '0' '0' '0']

function delcon!(list)
    list2 = [];
    for i in 1:length(list)
        breaker = false
        for C in cont
            if !contains(list[i], C)
                breaker = true
                break
            end
        end
        for C in isnot
            if contains(list[i], C)
                breaker = true
                break
            end
        end
        for C in isnoton
            if list[i][C[2]] == C[1] 
                breaker = true
                break
            end
        end
        for D in 1:length(solved)
            if '0' != solved[D] && solved[D] != list[i][D]
                breaker = true
                break
            end
        end
        if !breaker
            push!(list2,list[i])
        end
    end
    list = list2;
    return list2;
end

function countchar(list)
    println(countmap(join(list)))
end

function addtoarray(str)
    char = str[1]
    if length(str) > 5 && str[1:5] == "cont "
        println(findclosestwith(str[6:length(str)]))
    elseif length(str) > 6 && str[1:6] == "clear "
        try     
            i = parse(Int, str[7:length(str)])
            if  (i == 1) global cont = []
            elseif (i == 2) global isnot = []
            elseif (i == 3) global isnoton = []
            elseif (i == 4) global solved = ['0' '0' '0' '0' '0']
            end
        catch e
        end 
    elseif length(str) == 3 && str[2] == ' '
        if str[3] == 'n'
            push!(isnot,char)
        elseif isdigit(str[3])
            solved[parse(Int8, str[3])] = char
        end
    elseif length(str) == 4 && str[2] == ' '
        if str[3] == 'n' && isdigit(str[4])
            push!(isnoton,(char, parse(Int8,str[4])))
            push!(cont,char)
        end
    end
end

function printarrays()
    println("Contains: $cont")
    println("Is not in: $isnot")
    println("Is not on: $isnoton")
    println("Solved: $solved")
end

function findclosestwith(str)
    list2 = []
    for ele in LIST
        same = []
        for i in 1:5
            if contains(str, ele[i])
                push!(same,ele[i])
            end
        end
        if !isempty(same)
            len_ = length(same)
            unique!(same)
            value = 1000 * length(same)
            #value += 100 * len_
            #value -= 300 * count(x->in(x,cont), ele)
            value -= 750 * count(x->in(x,isnot), ele)
            for tup in isnoton
                if ele[tup[2]] == tup[1]
                    value -= 750
                end
            end
            for i in 1:5
                if ele[i] == solved[i]
                    value -= 900
                end
            end
            push!(list2, (value,ele))
        end
    end
    sort!(list2, rev=true)
    return isempty(list2) ? "error" : list2[1:10];
end



function find4()
    bestlist = copy(LIST)
    #=
    println(length(filter(x -> x[1] == 'q', bestlist)))
    println(length(filter(x -> x[2] == 'q', bestlist)))
    println(length(filter(x -> x[3] == 'q', bestlist)))
    println(length(filter(x -> x[4] == 'q', bestlist)))
    println(length(filter(x -> x[5] == 'q', bestlist)))
    =#
    filter!(x -> !contains(x, r"[w,v,z,x,j,q]"), bestlist)
    println(length(bestlist))
    #println(bestlist)
    filter!(x -> length(unique(x)) == 5, bestlist)
    println(length(bestlist))
    #bestlist = [ele for ele in map(prod, collect(Base.product(bestlist, bestlist)))]
    bestlist = [ele*ele2 for ele in bestlist for ele2 in bestlist]
    filter!(x -> length(unique(x)) == 10, bestlist)
    println(length(bestlist))

    bnflist = filter(x -> contains(x,"b") && !contains(x,"f"), bestlist)
    fnblist = filter(x -> contains(x,"f") && !contains(x,"n"), bestlist)

    for eleb in bnflist, elef in fnblist
        if length(unique(eleb*elef)) == 20
            println(eleb*elef)
        end
    end
end

function histogram(letter::Char)
    println(length(filter(x -> x[1] == letter, LIST)))
    println(length(filter(x -> x[2] == letter, LIST)))
    println(length(filter(x -> x[3] == letter, LIST)))
    println(length(filter(x -> x[4] == letter, LIST)))
    println(length(filter(x -> x[5] == letter, LIST)))
end

str = ""
while str != "exit"
    global str = ""

    while str != "next" && str != "exit"
        global str = readline(stdin)
        if str[1:4] == "hist" && length(str) >= 6
            histogram(str[6])
        elseif str != "next" && str != "exit"
            addtoarray(str)
            printarrays()
        end
    end

    global list = delcon!(list)
    countchar(list)
    println(length(list))
    println(list)
end