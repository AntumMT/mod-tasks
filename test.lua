
tasks.register("foo", {title="Foo Task", logic=function(self)
	core.log("executing logic for " .. self.title)
end})

tasks.register("bar", {title="Bar Task", logic=function(self)
	core.log("executing logic for " .. self.title)
end})
