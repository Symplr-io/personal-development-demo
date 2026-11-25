// Expo Go has no native module for react-native-get-random-values (its ExpoRandom
// fallback is gone from the SDK), so crypto.getRandomValues and randomUUID come from
// expo-crypto, which Expo Go ships. The idempotency key and the PKCE verifier use them.
import { getRandomValues, randomUUID } from 'expo-crypto';
import { registerRootComponent } from 'expo';
import App from './App';

const g = globalThis as unknown as { crypto?: object };
g.crypto = { ...g.crypto, getRandomValues, randomUUID };

registerRootComponent(App);
