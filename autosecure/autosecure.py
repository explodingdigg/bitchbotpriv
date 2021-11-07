import re, random, requests

key = "75cee0ee-2cb3-416d-93d7-97dbd4499537"
vms = ["SX_VM_A()", "SX_VM_B()", "SX_VM_C()"]

while True:
    print("auto secure lua $")
    while True:
        filelocation = input("file location: ")
        try:
            file = open(filelocation, "r", encoding = 'UTF8')
            filetext = file.read()
            file.close()
            break
        except:
            print("invalid file")

    print("applying changes...")
    p = re.compile(r"\bfunction\b\s*([\w:._]*?)\s*\((.*?)\)\s*((?:.|\n)*?)")

    splitlines = filetext.splitlines(True)
    newfile = ""
    for i in range(len(splitlines)):
        newfile += p.sub("function \g<1>(\g<2>) %s\n" % vms[random.randint(0, 2)], splitlines[i])
        
    print("added vms!")

    print(newfile)
    while True:
        opt = input("choose an option\n1. save file\n2. secure then save file\n3. obfuscate with no vms\n4. exit\n")
        filename = filelocation.replace(".", "_obf.")

        if opt == "1":
            print("saving...")
            file = open(filename , "w")
            file.write(newfile, encoding = "UTF8")
            file.close()
            print("saved " + filename)
            break
        elif opt == "2":
            print("uploading to 3ds's website...")
            r = requests.post("http://slua.3ds.moe:51923/obfuscate", params = {"ApiKey" : key}, data = newfile.encode("UTF8"), headers = {"Content-Type" : "raw"})
            print(r.status_code)
            print("done securing or something")
            print("saving...")
            file = open(filename , "w")
            file.write(r.text)
            file.close()
            print("saved " + filename)
            break
        elif opt == "3":
            print("uploading to 3ds's website...")
            r = requests.post("http://slua.3ds.moe:51923/obfuscate", params = {"ApiKey" : key}, data = filetext.encode("UTF8"), headers = {"Content-Type" : "raw"})
            print(r.status_code)
            print("done securing or something")
            print("saving...")
            file = open(filename , "w")
            file.write(r.text)
            file.close()
            print("saved " + filename)
            break
        elif opt == "4":
            print("exitting")
            break
        else:
            print("invalid option")
    again = input("secure another file? (yes/no)\n")
    if again != "yes":
        break

