import axios from 'axios'

export function createPromise(promise, successFunction, errorFunction) {
	return promise.then(function (response) {
		successFunction(response.data);
	}).catch(errorFunction);
}