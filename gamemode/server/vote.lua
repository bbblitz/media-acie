
--create_vote("string1","string2")
local function create_vote(...)
	local options = {...}
	local vote = {}
	vote.canvote = {}
	vote.voted = {}
	vote.tally = {}
	for k,v in pairs(options) do
		vote.tally[v] = 0
	end
	vote.observing = {}
	vote.add_observer = function(self,ply)
		self.observing[ply] = true
	end
	vote.remove_observer = function(self,ply)
		self.observing[ply] = nil
	end
	vote.finish = function(self)
		self.observing = {}
	end
	vote.add_voter = function(self,ply)
		self.canvote[ply] = true
	end
	vote.tally_vote = function(self,ply,option)
		local votedfor = self.voted[ply]
		if votedfor ~= nil then
			self.tally[votedfor] = self.tally[votedfor] - 1
		end
		self.tally[option] = self.tally[option] + 1
		self.voted[ply] = option
		
		for ply,_ in pairs(self.observing) do
			net.Start("notify_vote")
			if votedfor ~= nil then
				net.WriteString(votedfor)
				net.WriteUInt(self.tally[votedfor],8)
			end
			net.WriteString(option)
			net.WriteUInt(self.tally[option],8)
			net.Send(ply)
		end
	end
	
	return vote
end
