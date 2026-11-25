// First, so crypto is in place before any module of the app is evaluated.
import './polyfills';
import { registerRootComponent } from 'expo';
import App from './App';

registerRootComponent(App);
