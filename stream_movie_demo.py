#!/usr/bin/env python3
"""
MOVIE STREAMING TO QUANTUM NETWORK DEMO
Demonstrates streaming a movie from the internet through the quantum network
"""

import sys
import os

# Add the quantum-internet directory to path
sys.path.insert(0, os.path.dirname(__file__))

from deploy_ai_agents_security import AIAgentDeployment

def main():
    print("🎬 QUANTUM MOVIE STREAMING DEMO")
    print("=" * 40)

    # Example movie URLs (you can replace with any valid movie URL)
    example_urls = {
        '1': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        '2': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
        '3': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4'
    }

    print("Available demo movies:")
    print("1. Sample Video 1MB (fast test)")
    print("2. Sample Video 2MB (medium test)")
    print("3. Sample Video 5MB (larger test)")
    print("4. Custom URL (enter your own)")

    choice = input("\nSelect movie to stream (1-4): ").strip()

    movie_url = None
    if choice in ['1', '2', '3']:
        movie_url = example_urls[choice]
        print(f"📥 Selected: {movie_url}")
    elif choice == '4':
        movie_url = input("Enter movie URL: ").strip()
    else:
        print("❌ Invalid choice")
        return

    print("\n🚀 Starting quantum network deployment...")
    deployment = AIAgentDeployment()

    try:
        # Stream the movie through the quantum network
        result = deployment.stream_movie_from_internet_to_quantum_network(movie_url)

        print("\n🎉 STREAMING COMPLETE!")
        print("=" * 30)
        print(f"📊 Data streamed: {result['transmission_metrics']['total_data_transmitted']:,} bytes")
        print(f"⚛️ Quantum chunks: {result['transmission_metrics']['quantum_chunks_processed']:,}")
        print(f"⏱️ Transmission time: {result['transmission_metrics']['end_to_end_time']}")
        print(f"🛡️ Data integrity: {result['transmission_metrics']['data_integrity']}")

        if result['binary_reconstruction']['output_file']:
            print(f"💾 Output file: {result['binary_reconstruction']['output_file']}")

    except KeyboardInterrupt:
        print("\n⏹️ Streaming interrupted by user")
    except Exception as e:
        print(f"❌ Error during streaming: {e}")

if __name__ == "__main__":
    main()