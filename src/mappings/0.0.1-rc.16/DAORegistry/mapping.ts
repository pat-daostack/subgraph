import 'allocator/arena';

import { Address, BigInt, store } from '@graphprotocol/graph-ts';

// Import event types from the Token contract ABI
import { DAORegistry, Propose, Register, UnRegister } from '../../../types/DAORegistry/0.0.1-rc.16/DAORegistry';

import * as domain from '../../../domain';

export function handlePropose(event: Propose): void {
  domain.daoRegister(event.params._avatar, 'proposed');
}

export function handleRegister(event: Register): void {
  domain.daoRegister(event.params._avatar, 'registered');
}

export function handleUnRegister(event: UnRegister): void {
  domain.daoRegister(event.params._avatar, 'unRegistered');
}