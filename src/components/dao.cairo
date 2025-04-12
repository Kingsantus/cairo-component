#[starknet::component]
pub mod DAOComponent {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess,};
    use crate::interfaces::dao::IDAO;
    use crate::interfaces::voting::IVote;
    use crate::components::voting::VotingComponent;

    #[storage]
    pub struct Storage {
        something: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
    }

    #[embeddable_as(DAOImpl)]
    pub impl DAO<TContractState, +HasComponent<TContractState>, +Drop<TContractState>, impl Vote:VotingComponent::HasComponent<TContractState>> of IDAO<ComponentState<TContractState>> {
        fn do_something(ref self: ComponentState<TContractState>) {
            let mut voting_component = get_dep_component_mut!(ref self, Vote);
            let name: ByteArray = "King";
            let description: ByteArray = "My desc";
            let id = voting_component.create_poll(name, description);
        }

        fn get_something(self: @ComponentState<TContractState>) {

        }
    }
}