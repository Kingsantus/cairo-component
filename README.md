We learnt about component in starknet, components are modular adds on encapsulating resuable logic, storage, and event, that can be comperated into multiple contracts. It cannot be declared or deployed and it implementation takes #[embeddable_as(name)] where name is used to assess the compomonent function from outside. components is defined with #[starknet::components]. unlike contract that goes with VoteImpl of super::IVote<ContractState> it goes with VoteImpl<TContractState, +HasComponent<TContractState>> of super::IVote<ComponentState<TContractState>>
get_dep_component!() to read from a component function
get_dep_component_mut() to change or write intoa function
when importing component into a contract it takes #[substorage(v0)] which point to the storage in the component, the contract dont need to have same variable in component as it will conflict

# upgradability
replace_call_syscall system call enabling simple contract upgrades without affecting the contrat's state. Starknet allows contract to be upgradable, where a deployed contract which is immutable can be changed to be better.
# cairo-component
