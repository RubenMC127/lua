local function Pet(name)
    return {
        -- variables
        name = name or "Eustaquio",
        status = "Hungry",

        -- functions
        feed = function(self)
            print(self.name .. " is eating...")
            self.status = "Full"
        end
    }
end

local function Dog(name, breed)
    local dog = Pet(name) -- "Inheritance"
    dog.breed = breed
    dog.loyalty = 0
    
    dog.is_loyal = function(self)
        return self.loyalty >= 10
    end

    dog.bark = function(self)
        print("Woof Woof!")
    end

    dog.feed = function(self)
        print("PLUS 6!")
        self.loyalty = self.loyalty + 6;
    end

    return dog
end

local nasus = Dog("Nasus", "Chacal")
nasus:feed()
nasus:feed()
nasus:bark()

if nasus:is_loyal() then
    print("Will protect you")
else
    print("Will not protect you")
end

--local dog = Pet()
--print("dog name: " .. dog.name)
--print(dog.name .. " status: " .. dog.status)
--dog:feed()
--print(dog.name .. " status: " .. dog.status)
