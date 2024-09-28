// axiosInstance.js
import axios from 'axios';

const baseURL: string = import.meta.env.VITE_API_URL;

const axiosInstance = axios.create({
  baseURL: baseURL
});

// You can also add interceptors for logging or token handling if needed
axiosInstance.interceptors.request.use(
  (config) => {
    // Modify the request before sending it, e.g., attach an auth token
    // config.headers['Authorization'] = `Bearer ${token}`;
    return config;
  },
  (error) => Promise.reject(error)
);

export default axiosInstance;
