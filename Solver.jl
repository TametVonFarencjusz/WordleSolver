using StatsBase
include("Helper.jl")

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

LIST = onlyletters(LIST)
LIST = [convert(x) for x in LIST]
unique!(LIST)
list = copy(LIST)

#count letters dict
println(length(LIST))
countdict = countmap(collect(join(LIST)))
println(countdict)


println("Pick style: basic/filter")
str = readline(stdin)
if str == "filter"
    #=open(lang*"_filter.txt", "w") do file
        for ele in LIST
            println(ele)
            str = readline(stdin)
            if lowercase(str) in ("y", "yes", "t")
                write(file, ele)
            end
        end
    end=#
else
    #starting values
    cont = []
    isnot = []
    isnoton = []
    solved = ['0' '0' '0' '0' '0']

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
end