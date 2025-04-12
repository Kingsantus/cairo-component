#[starknet::component]
pub mod VotingComponent {
    use starknet::{
        ContractAddress,
        get_caller_address
    };
    use starknet::storage::{
        StoragePointerReadAccess,
        StoragePointerWriteAccess,
        StoragePathEntry,
        Map
    };
    use crate::interfaces::voting::*;

    #[storage]
    pub struct Storage {
        polls: Map<u256, Poll>,
        voters: Map<(ContractAddress, u256), bool>,
        nounce: u256
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Voted: Voted
    }

    #[embeddable_as(VotingImpl)]
    pub impl Voting<TContractState, +HasComponent<TContractState>> of IVote<ComponentState<TContractState>> {
        fn create_poll(ref self: ComponentState<TContractState>, name: ByteArray, desc: ByteArray) -> u256 {
            let id = self.nounce.read() + 1;
            assert!(name != "" && desc != "", "NAME OR DESC IS EMPTY");
            let mut poll: Poll = Default::default();
            poll.name = name;
            poll.desc = desc;
            self.polls.entry(id).write(poll);
            self.nounce.write(id);
            id
        }

        fn vote(ref self: ComponentState<TContractState>, support: bool, id: u256) {
            let mut poll = self.polls.entry(id).read();
            assert(poll != Default::default(), 'INVALID POLL');
            assert(poll.status == Default::default(), 'POLL NOT PENDING');
            let caller = get_caller_address();
            let has_voted = self.voters.entry((caller,id)).read();
            assert(!has_voted, 'CALLER HAS VOTED');
            match support {
                true => poll.yes_votes += 1,
                _ => poll.no_votes += 1
            }
            let vote_count = poll.yes_votes + poll.no_votes;
            if vote_count >= DEFAULT_THRESHOLD {
                poll.resolve();
            }
            self.polls.entry(id).write(poll);
            self.voters.entry((caller, id)).write(true);
            self.emit(Event::Voted(Voted {id, voter: caller}));
        }

        // fn resolve_poll(ref self: ComponentState<TContractState>, id: u256) {

        // }

        fn get_poll(self: @ComponentState<TContractState>, id: u256) {
            self.polls.entry(id).read();
        }
    }

}