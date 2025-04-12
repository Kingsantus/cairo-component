#[starknet::interface]
pub trait IDAO<TContractState> {
    fn do_something(ref self: TContractState);
    fn get_something(self: @TContractState);
}