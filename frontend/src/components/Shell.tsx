import { useEffect, useState } from "react";
import axiosInstance from "../api/axiosInstance"

function Shell() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    // Replace with your backend API URL
    axiosInstance
      .get("/Products")
      .then((response) => {
        setData(response.data); // Handle the data from the response
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message); // Handle errors
        setLoading(false);
      });
  }, []); // Empty array ensures this runs only once after the component mounts

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error}</p>;

  return (
    <div>
      <h1>Fetched Data Hello World</h1>
      <ul>
        {data.map((item: Product) => (
          <li key={item.id}>{item.name} - {item.price}</li> // Displaying the data
        ))}
      </ul>
    </div>
  );
}

interface Product {
    id: number
    name: string
    price: number
}

export default Shell;
