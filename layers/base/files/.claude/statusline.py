#!/usr/bin/env python3

import json
import sys


def main():
    payload = json.load(sys.stdin)
    context = payload["context_window"]
    tokens = context["total_input_tokens"] + context["total_output_tokens"]
    line = (
        f"{payload['model']['display_name']} ({payload['effort']['level']})"
        f" | {tokens} tokens | {context['used_percentage']:.0f}%"
        f" | ${payload['cost']['total_cost_usd']:.2f}"
    )
    print(f"\033[2m{line}\033[0m", end="")


if __name__ == "__main__":
    main()
